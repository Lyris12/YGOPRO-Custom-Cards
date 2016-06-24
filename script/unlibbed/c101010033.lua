--Change all monsters your opponent controls to face-up Attack Position, and if you do, those monsters cannot change their Battle Position, also, they must attack this card next turn.
--FFD-Eternity
function c101010551.initial_effect(c)
	--bounce
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e0:SetCode(EVENT_DAMAGE_STEP_END)
	e0:SetRange(LOCATION_MZONE)
	e0:SetCondition(c101010551.rtcon)
	e0:SetTarget(c101010551.rttg)
	e0:SetOperation(c101010551.rtop)
	c:RegisterEffect(e0)
	--fusion summon
	c:EnableReviveLimit()
	aux.AddFusionProcFun2(c,c101010551.ffilter1,c101010551.ffilter2,true)
end
function c101010551.ffilter1(c)
	return c:IsAttribute(ATTRIBUTE_FIRE) or (c:IsHasEffect(101010560) and not c:IsLocation(LOCATION_DECK))
end
function c101010551.FConditionFilterF2c(c)
	return c:IsRace(RACE_DRAGON) or (c:IsHasEffect(101010576) and not c:IsLocation(LOCATION_DECK))
end
function c101010551.rtcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsRelateToBattle()
end
function c101010551.filter(c)
	return c:IsFaceup() and c:IsAttackPos()
end
function c101010551.rttg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c101010551.filter,tp,0,LOCATION_MZONE,1,nil) end
end
function c101010551.splimit(c)
	return c:IsHasEffect(101010552)
end
function c101010551.rtop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c101010551.filter,0,0,LOCATION_MZONE,nil)
	local tc=g:GetFirst()
	if g:GetCount()>0 then
		if not c:IsHasEffect(101010552) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e1:SetCode(EVENT_PRE_BATTLE_DAMAGE)
			e1:SetCondition(function(e,tp,eg,ep,ev,re,r,rp) return ep~=tp end)
			e1:SetOperation(function(e,tp,eg,ep,ev,re,r,rp) Duel.ChangeBattleDamage(ep,ev/2) end)
			e1:SetReset(RESET_EVENT+0x1fe0000+RESET_CHAIN)
			c:RegisterEffect(e1)
		end
		local tc=g:GetFirst()
		while tc do
			if tc:IsHasEffect(EFFECT_INDESTRUCTABLE_BATTLE) then
				local e0=Effect.CreateEffect(c)
				e0:SetType(EFFECT_TYPE_SINGLE)
				e0:SetCode(EFFECT_DISABLE)
				e0:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
				e0:SetReset(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e0)
				local e2=Effect.CreateEffect(c)
				e2:SetType(EFFECT_TYPE_SINGLE)
				e2:SetCode(EFFECT_DISABLE_EFFECT)
				e2:SetProperty(EFFECT_FLAG_IGNORE_IMMUNE)
				e2:SetReset(RESET_EVENT+0x1fe0000)
				tc:RegisterEffect(e2)
			end
			Duel.CalculateDamage(tc,c)
			g:RemoveCard(tc)
			tc=g:GetNext()
		end
	end
end