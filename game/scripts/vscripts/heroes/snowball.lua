snowball_lua = class({})

function snowball_lua:OnSpellStart()
    local caster = self:GetCaster()
    local ability = self

    caster:EmitSound("Hero_Tusk.Snowball.Cast")

    local casterAngles = caster:GetAngles()
    caster:SetAngles(casterAngles.x, casterAngles.y, casterAngles.z)
    caster:AddNewModifier(caster, ability, "modifier_sliding", {})
    -- caster:AddNoDraw()
end

LinkLuaModifier("modifier_sliding", "heroes/snowball", LUA_MODIFIER_MOTION_HORIZONTAL)

modifier_sliding = class({})

function modifier_sliding:GetModifierModelChange()
    return "models/particle/snowball.vmdl"
end

function modifier_sliding:CheckState()
    local funcs = {
        [MODIFIER_STATE_DISARMED] = true,
        [MODIFIER_STATE_NO_HEALTH_BAR] = true,
        [MODIFIER_STATE_NO_UNIT_COLLISION] = true,
    }
    return funcs
end

function modifier_sliding:GetVisualZDelta()
    return (self.baseRadius * self:GetStackCount()) or 20
end

function modifier_sliding:IsHidden()
    return false
end

function modifier_sliding:OnCreated(kv)
    self.baseSpeed = 50
    self.baseScale = 0.2
    
    self.maxSpeed = 400
    self.speedStep = 8
    self.currentSpeed = 50
    self.scale = 0.2
    self.hitRadius = 50
    self.turnRate = 120
    self.baseRadius = 50
    
    if IsServer() then
        self.targetAngle = self:GetParent():GetAnglesAsVector().y
        self.ricocheting = false

        self:SetStackCount(self.scale)
        self:GetParent():SetModelScale(self.scale)

        self:GetParent():EmitSound("Hero_Tusk.Snowball.Loop")

        self.snowballPfx = ParticleManager:CreateParticle("particles/units/heroes/hero_tusk/tusk_snowball.vpcf", PATTACH_ABSORIGIN_FOLLOW, self:GetParent())
        ParticleManager:SetParticleControl(self.snowballPfx, 0, self:GetParent():GetOrigin())
        ParticleManager:SetParticleControl(self.snowballPfx, 2, Vector(self.currentSpeed, 0, 0))
        ParticleManager:SetParticleControl(self.snowballPfx, 3, Vector(self.baseRadius, self.baseRadius, self.baseRadius))

        if self:ApplyHorizontalMotionController() == false then 
            print("Couldn't apply motion controller")
            self:StopRolling()
            return
        end

        self:StartIntervalThink(FrameTime())
    end
end

function modifier_sliding:DeclareFunctions()
    local funcs = 
    {
        MODIFIER_PROPERTY_MODEL_CHANGE,
        MODIFIER_EVENT_ON_ORDER,
        MODIFIER_PROPERTY_DISABLE_TURNING,
        MODIFIER_PROPERTY_VISUAL_Z_DELTA,
    }
    return funcs
end

function modifier_sliding:GetModifierDisableTurning()
    return 1
end

function modifier_sliding:SetTarget(target)
    if (target) then
        self.targetAngle = VectorToAngles(target - self:GetParent():GetOrigin()).y
    else
        self.targetAngle = self:GetParent():GetAngles().y
    end
end

function modifier_sliding:StopRolling()
    self:GetParent():RemoveHorizontalMotionController(self)
    self.currentlyInterrupted = true
end

function modifier_sliding:UpdateHorizontalMotion(me, dt)
    if not IsServer() then return end
    if self.currentlyInterrupted then return end

    local parent = self:GetParent()
    local turnAmount = 0.0
    local currentAngles = parent:GetAngles()

    if parent:IsStunned() or parent:IsRooted() then
        self:StopRolling()
        return
    end

    local origin = me:GetOrigin()
    
    self.scale = self.scale + 0.001
    self:GetParent():SetModelScale(self.scale)
    self:SetStackCount(self.scale)

    local hitRadius = (self.baseRadius * self.scale) / 2
    local forwardPosition = origin + me:GetForwardVector() * hitRadius
    local blockers = Entities:FindAllByClassnameWithin("npc_dota_thinker", forwardPosition, hitRadius)
    local maybeBlocker = GetRandomTableElement(blockers)
   
    if GridNav:IsTraversable(forwardPosition) == false or (maybeBlocker and maybeBlocker:IsBaseNPC() and maybeBlocker:IsPhantomBlocker()) then
        self.ricocheting = true
        self:StopRolling()

        parent:EmitSound("Hero_Tusk.Snowball.ProjectileHit")

        Timers:CreateTimer(0.2, function()
            local angle = parent:GetAnglesAsVector()
            parent:SetAbsAngles(angle.x, angle.y + 180, angle.z)

            Timers:CreateTimer(0.2, function()
                self.ricocheting = false
            end)
        end)

        return
    end

    -- Turn Logic
    local parentAngle = parent:GetAnglesAsVector()
    local angleDiff = AngleDiff(self.targetAngle, parentAngle.y)
    -- min of 10 and max of 90
    local turnRate = math.min(1.1 * self.turnRate * dt, math.abs(angleDiff))
    parent:SetAbsAngles(parentAngle.x, parentAngle.y + turnRate * Sign(angleDiff), parentAngle.z)

    me:SetOrigin(origin + me:GetForwardVector() * self.currentSpeed * dt)

    self.scale = self.scale + 0.001
    self.currentSpeed = math.min(self.currentSpeed + self.speedStep, self.maxSpeed)

    self:UpdateSnowballParticle()
end

function modifier_sliding:OnIntervalThink()
    if (self.currentlyInterrupted) then
        local parent = self:GetParent()
        local stillInterrupted =
            parent:IsStunned() or
            parent:IsRooted() or
            parent:IsCurrentlyHorizontalMotionControlled() or
            self.ricocheting

        if not stillInterrupted and self:ApplyHorizontalMotionController() then
            self.currentlyInterrupted = false
        end
    end
end

function modifier_sliding:UpdateSnowballParticle()
    if IsServer() then
        local parent = self:GetParent()
        local radius = self.scale * self.baseRadius
        ParticleManager:SetParticleControl(self.snowballPfx, 0, self:GetParent():GetOrigin())
        ParticleManager:SetParticleControl(self.snowballPfx, 2, Vector(self.currentSpeed, 0, 0))
        ParticleManager:SetParticleControl(self.snowballPfx, 1, parent:GetAbsOrigin() + parent:GetForwardVector() * 100)
        ParticleManager:SetParticleControl(self.snowballPfx, 3, Vector(radius, radius, radius))
    end
end

function modifier_sliding:OnOrder(params)
    if IsServer() then
        if params.order_type == DOTA_UNIT_ORDER_MOVE_TO_POSITION or params.order_type == DOTA_UNIT_ORDER_ATTACK_MOVE then
            if params.unit == self:GetParent() then
                local direction = params.new_pos - self:GetParent():GetOrigin()
                direction.z = 0
                direction = direction:Normalized()
                local angles = VectorAngles(direction)
                self.targetAngle = angles.y
            end
        end
    end
    return 0
end

function modifier_sliding:GetModifierDisableTurning(params)
    return 1
end

function modifier_sliding:OnHorizontalMotionInterrupted(prams)
    self:StopRolling()
end

function modifier_sliding:OnDestroy()
    if not IsServer() then return end
    self:GetParent():StopSound("Hero_Tusk.Snowball.Loop")
    self:GetParent():RemoveNoDraw()
end