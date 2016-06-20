--ＳＳ－轟く潮ジノバシル
local id,ref=GIR()
function ref.start(c)
--synchro summon
	aux.AddSynchroProcedure(c,nil,aux.NonTuner(nil),1)
	c:EnableReviveLimit()
	--cannot special summon
	local e2=Effect.CreateEffect(c)
	e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e2:SetType(EFFECT_TYPE_SINGLE)
	e2:SetRange(LOCATION_EXTRA)
	e2:SetCode(EFFECT_SPSUMMON_CONDITION)
	c:RegisterEffect(e2)
	--mat check
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_MATERIAL_CHECK)
	e0:SetValue(ref.matcheck)
	c:RegisterEffect(e0)
	--atkup
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_UPDATE_ATTACK)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCondition(ref.atkcon)
	e1:SetValue(200)
	e1:SetLabelObject(e0)
	c:RegisterEffect(e1)
	--attack
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e3:SetCode(EVENT_BATTLE_DAMAGE)
	e3:SetRange(LOCATION_MZONE)
	e3:SetCondition(ref.con)
	e3:SetCost(ref.tg)
	e3:SetOperation(ref.op)
	c:RegisterEffect(e3)
	--[[if not ref.global_check then
		ref.global_check=true
		local ge1=Effect.CreateEffect(c)
		ge1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge1:SetCode(EVENT_ATTACK_ANNOUNCE)
		ge1:SetOperation(ref.checkop)
		Duel.RegisterEffect(ge1,0)
		local ge2=Effect.CreateEffect(c)
		ge2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
		ge2:SetCode(EVENT_ATTACK_DISABLED)
		ge2:SetOperation(ref.check2)
		Duel.RegisterEffect(ge2,0)
		ge2:SetLabelObject(ge1)
		e3:SetLabelObject(ge1)
	end]]
end
function ref.matcheck(e,c)
	local g=c:GetMaterial()
	local pavr=0
	local tc=g:GetFirst()
	while tc do
		if tc:IsAttribute(ATTRIBUTE_WATER) and tc:GetLevel()==6 then pavr=pavr+1 end
		tc=g:GetNext()
	end
	e:SetLabel(pavr)
end
function ref.atkcon(e)
	return e:GetLabelObject():GetLabel()~=0
end
--[[function ref.checkop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local tc=eg:GetFirst()
	local ct=e:GetLabel()
	if tc~=c then
		if ct~=0 then
			e:SetLabel(ct+1)
			else
			e:SetLabel(1)
		end
	end
end
function ref.check2(e,tp,eg,ep,ev,re,r,rp)
	local tc=eg:GetFirst()
	local ct=e:GetLabelObject():GetLabel()
	if ct~=0 then
		e:SetLabel(ct-1)
	end
end]]
function ref.con(e,tp,eg,ep,ev,re,r,rp)
	return Duel.GetTurnPlayer()==tp and Duel.GetFieldGroupCount(tp,0,LOCATION_ONFIELD)>Duel.GetFieldGroupCount(tp,LOCATION_ONFIELD,0)
end
function ref.filter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsDiscardable()
end
function ref.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(ref.filter,tp,LOCATION_HAND,0,1,nil) end
	Duel.DiscardHand(tp,ref.filter,1,1,REASON_COST,nil)
end
function ref.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(Card.IsAttackable,tp,LOCATION_MZONE,0,c)
	local tc=g:GetFirst()
	while tc do
		local e0=Effect.CreateEffect(c)
		e0:SetType(EFFECT_TYPE_SINGLE)
		e0:SetCode(EFFECT_EXTRA_ATTACK)
		e0:SetValue(1)
		e0:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e0)
		tc=g:GetNext()
	end
end