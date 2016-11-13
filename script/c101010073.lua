--created & coded by Lyris
--光の波動
function c101010073.initial_effect(c)
--Activate(effect)
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101010073,0))
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCategory(CATEGORY_NEGATE+CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e1:SetCode(EVENT_CHAINING)
	e1:SetCondition(c101010073.condition1)
	e1:SetCost(c101010073.cost)
	e1:SetTarget(c101010073.target1)
	e1:SetOperation(c101010073.activate1)
	c:RegisterEffect(e1)
	--Activate(attack)
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_ACTIVATE)
	e2:SetDescription(aux.Stringid(101010073,1))
	e2:SetCategory(CATEGORY_DAMAGE+CATEGORY_DESTROY)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCondition(c101010073.condition2)
	e2:SetCost(c101010073.cost)
	e2:SetTarget(c101010073.target2)
	e2:SetOperation(c101010073.activate2)
	c:RegisterEffect(e2)
end
function c101010073.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.CheckReleaseGroup(tp,Card.IsAttribute,1,nil,ATTRIBUTE_LIGHT) end
	local g=Duel.SelectReleaseGroup(tp,Card.IsAttribute,1,1,nil,ATTRIBUTE_LIGHT)
	Duel.Release(g,REASON_COST)
end
function c101010073.condition1(e,tp,eg,ep,ev,re,r,rp)
	return ep~=tp and re:IsActiveType(TYPE_MONSTER) and Duel.IsChainNegatable(ev)
end
function c101010073.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return true end
	Duel.SetOperationInfo(0,CATEGORY_NEGATE,eg,1,0,0)
	if re:GetHandler():IsDestructable() and re:GetHandler():IsRelateToEffect(re) then
		Duel.SetOperationInfo(0,CATEGORY_DESTROY,eg,1,0,0)
	end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,0)
end
function c101010073.activate1(e,tp,eg,ep,ev,re,r,rp)
	Duel.NegateActivation(ev)
	if re:GetHandler():IsRelateToEffect(re) and Duel.Destroy(eg,REASON_EFFECT)~=0 then
		Duel.BreakEffect()
		if eg:GetFirst():IsLocation(LOCATION_GRAVE) then
			local atk=re:GetHandler():GetAttack()
			if atk<0 then atk=0 end
			Duel.Damage(1-tp,atk,REASON_EFFECT,true)
			Duel.Damage(tp,atk,REASON_EFFECT,true)
			Duel.RDComplete()
		end
	end
end
function c101010073.condition2(e,tp,eg,ep,ev,re,r,rp)
	return tp~=Duel.GetTurnPlayer()
end
function c101010073.target2(e,tp,eg,ep,ev,re,r,rp,chk)
	local tg=Duel.GetAttacker()
	if chk==0 then return tg:IsOnField() and tg:IsDestructable() end
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,tg,1,0,0)
	local dam=tg:GetAttack()
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,PLAYER_ALL,dam)
end
function c101010073.activate2(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetAttacker()
	if tg:IsAttackable() and Duel.Destroy(tg,REASON_EFFECT)~=0 and not tg:IsStatus(STATUS_ATTACK_CANCELED) then
		Duel.BreakEffect()
		if tg:IsLocation(LOCATION_GRAVE) then
			local atk=tg:GetAttack()
			if atk<0 then atk=0 end
			Duel.Damage(1-tp,atk,REASON_EFFECT,true)
			Duel.Damage(tp,atk,REASON_EFFECT,true)
			Duel.RDComplete()
		end
	end
end
