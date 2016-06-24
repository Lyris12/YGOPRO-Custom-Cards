--機夜行襲雷竜－モルニング
local id,ref=GIR()
function ref.initial_effect(c)
	c:EnableReviveLimit()
	--add race
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetTarget(ref.atcon)
	e0:SetRange(0xf3)
	e0:SetTargetRange(0xf3,0)
	e0:SetCode(EFFECT_ADD_ATTRIBUTE)
	e0:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e0)
	--fusion material
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e1:SetCode(EFFECT_FUSION_MATERIAL)
	e1:SetCondition(ref.fscondition)
	e1:SetOperation(ref.fsoperation)
	c:RegisterEffect(e1)
	--set atk & def
	local e4=Effect.CreateEffect(c)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetCondition(ref.succon)
	e4:SetOperation(ref.sucop)
	c:RegisterEffect(e4)
	--halve damage
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_CONTINUOUS+EFFECT_TYPE_SINGLE)
	e3:SetCode(EVENT_PRE_BATTLE_DAMAGE)
	e3:SetCondition(ref.hcon)
	e3:SetOperation(ref.hop)
	c:RegisterEffect(e3)
	--self-destruct
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_DESTROY)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e2:SetRange(LOCATION_MZONE)
	e2:SetCode(EVENT_ATTACK_ANNOUNCE)
	e2:SetCondition(ref.descon)
	e2:SetOperation(ref.desop)
	c:RegisterEffect(e2)
	--pos
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_POSITION)
	e5:SetType(EFFECT_TYPE_TRIGGER_O+EFFECT_TYPE_FIELD)
	e5:SetCode(EVENT_ATTACK_ANNOUNCE)
	e5:SetRange(LOCATION_MZONE)
	e5:SetCondition(ref.poscon)
	e5:SetTarget(ref.postg)
	e5:SetOperation(ref.posop)
	c:RegisterEffect(e5)
end
function ref.atcon(e,c)
	return c==e:GetHandler()
end
function ref.poscon(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local d=Duel.GetAttackTarget()
	return d and a:IsControler(tp) and a:IsSetCard(0x167)
end
function ref.postg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chk==0 then return true end
	local g=Duel.GetAttackTarget()
	Duel.SetTargetCard(g)
	Duel.SetOperationInfo(0,CATEGORY_POSITION,g,1,0,0)
end
function ref.filter(c)
	return c:IsSetCard(0x167)
end
function ref.posop(e,tp,eg,ep,ev,re,r,rp)
	local a=Duel.GetAttacker()
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and Duel.ChangePosition(tc,POS_FACEUP_DEFENCE,POS_FACEUP_DEFENCE,POS_FACEUP_ATTACK,POS_FACEUP_ATTACK,true)~=0 and ref.filter(a) then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_PIERCE)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		a:RegisterEffect(e1)
	end
end
function ref.ffilter(c,mg)
	return c:IsSetCard(0x167) and mg:IsExists(ref.fsfilter,1,c,c:GetCode())
end
function ref.fsfilter(c,code)
	return c:IsSetCard(0x167) and c:GetCode()~=code
end
function ref.fscondition(e,g,gc,chkf)
	if g==nil then return false end
	return g:IsExists(ref.ffilter,1,nil,g)
end
function ref.fsoperation(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
	--[[if gc then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local g1=eg:FilterSelect(tp,ref.fsilter,1,1,gc,gc:GetCode())
		local code=g1:GetFirst():GetCode()
		eg:Remove(Card.IsCode,nil,code)
		while eg:IsExists(ref.fsfilter,gc,code) do
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
			local g2=eg:FilterSelect(tp,ref.fsfilter,1,1,g1:GetFirst(),code)
			g1:AddCard(g2:GetFirst())
			code=g2:GetFirst():GetCode()
			eg:Remove(Card.IsCode,nil,code)
			if not Duel.SelectYesNo(tp,aux.Stringid(101010099,0)) then break end   
		end
		Duel.SetFusionMaterial(g1)
		return
	end
	local sg=eg:Filter(ref.ffilter,nil,eg)]]
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g1=eg:FilterSelect(tp,ref.ffilter,1,1,nil,eg)
	local code=g1:GetFirst():GetCode()
	eg:Remove(Card.IsCode,nil,code)
	while eg:IsExists(ref.fsfilter,1,g1:GetFirst(),code) do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local g2=eg:FilterSelect(tp,ref.fsfilter,1,1,g1:GetFirst(),code)
		g1:AddCard(g2:GetFirst())
		code=g2:GetFirst():GetCode()
		eg:Remove(Card.IsCode,nil,code)
		if not eg:IsExists(ref.fsfilter,1,g1:GetFirst(),code) or not Duel.SelectYesNo(tp,aux.Stringid(101010099,0)) then break end
	end
	Duel.SetFusionMaterial(g1)
end
function ref.succon(e)
	return bit.band(e:GetHandler():GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION
end
function ref.sucop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local atk=0
	local def=0
	local g=c:GetMaterial()
	if g:GetCount()>0 then
		local tc=g:GetFirst()
		while tc do
			local au=tc:GetAttack()
			local du=tc:GetDefence()
			if tc:IsPreviousLocation(LOCATION_MZONE) then
				au=tc:GetPreviousAttackOnField()
				du=tc:GetPreviousDefenceOnField()
			end
			atk=atk+au
			def=def+du
			tc=g:GetNext()
		end
		atk=math.floor(atk/2)
		def=math.floor(def/2)
		local e1=Effect.CreateEffect(c)
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_BASE_ATTACK)
		e1:SetValue(atk)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		c:RegisterEffect(e1)
		local e2=e1:Clone()
		e2:SetCode(EFFECT_SET_BASE_DEFENCE)
		e2:SetValue(def)
		c:RegisterEffect(e2)
	end
end
function ref.hcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return ep~=tp and bit.band(c:GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION and c:IsAttackAbove(3000)
end
function ref.hop(e,tp,eg,ep,ev,re,r,rp)
	Duel.ChangeBattleDamage(ep,ev/2)
end
function ref.descon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return Duel.GetTurnPlayer()~=tp and c:IsFaceup() and Duel.GetAttackTarget()==c
end
function ref.desop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.Destroy(c,REASON_EFFECT)
	end
end