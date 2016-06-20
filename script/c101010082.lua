--This card can attack your opponent directly, but when it does so using this effect, any battle damage it inflicts to your opponent is halved.
--ＳＳ－スピリット・キャンパー
function c101010207.initial_effect(c)
	--special summon
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SPSUMMON_PROC)
	e2:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	e2:SetRange(LOCATION_HAND)
	e2:SetCondition(c101010207.spcon)
	c:RegisterEffect(e2)
	--destroy
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(101010207,0))
	e1:SetCategory(CATEGORY_DESTROY)
	e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_TO_GRAVE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e1:SetCondition(c101010207.con1)
	e1:SetTarget(c101010207.tg1)
	e1:SetOperation(c101010207.op1)
	c:RegisterEffect(e1)
	local e0=Effect.CreateEffect(c)
	e0:SetDescription(aux.Stringid(101010207,0))
	e0:SetCategory(CATEGORY_DESTROY)
	e0:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e0:SetCode(EVENT_BE_MATERIAL)
	e0:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e0:SetCondition(c101010207.con2)
	e0:SetTarget(c101010207.tg2)
	e0:SetOperation(c101010207.op2)
	c:RegisterEffect(e0)
end
function c101010207.spfilter(c)
	return c:IsAttribute(ATTRIBUTE_WATER) and c:IsFaceup()
end
function c101010207.spcon(e,c)
	if c==nil then return true end
	local tp=e:GetHandler():GetControler()
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)<Duel.GetFieldGroupCount(tp,0,LOCATION_MZONE)
		and Duel.IsExistingMatchingCard(c101010207.spfilter,tp,LOCATION_MZONE,0,1,nil)
end
function c101010207.filter(c)
	return c:IsFaceup() and c:IsDestructable()
end
function c101010207.con2(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsLocation(LOCATION_GRAVE) and r==REASON_SYNCHRO
end
function c101010207.cfilter2(c)
	if c:GetFlagEffect(101010207)~=0 then return false end
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER) and (c:GetSummonLocation()==LOCATION_EXTRA and c:IsType(TYPE_SYNCHRO))
end
function c101010207.tg2(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local rc=e:GetHandler():GetReasonCard()
	if chkc then return chkc:IsOnField() and c101010207.filter(chkc) end
	if chk==0 then return rc:IsAttribute(ATTRIBUTE_WATER) and Duel.IsExistingMatchingCard(c101010207.cfilter2,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingTarget(c101010207.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,rc) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c101010207.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,rc)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c101010207.op2(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		if Duel.Destroy(tc,REASON_EFFECT)==0 then return end
		local atk=tc:GetTextAttack()
		if atk<0 then atk=0 end
		local c=e:GetHandler()
		local sc=c:GetReasonCard()
		if sc:IsFacedown() then return end
		sc:RegisterFlagEffect(101010207,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CANNOT_DISABLE,1)
		if tc:IsType(TYPE_MONSTER) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(atk/2)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			sc:RegisterEffect(e1)
			elseif tc:IsType(TYPE_SPELL) then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCode(EFFECT_DESTROY_REPLACE)
			e2:SetTarget(c101010207.indtg)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			sc:RegisterEffect(e2)
			else
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
			e3:SetValue(1)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			sc:RegisterEffect(e3)
		end
	 end
end
function c101010207.con1(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():IsReason(REASON_SYNCHRO)
end
function c101010207.tg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	local rc=e:GetHandler():GetReasonCard()
	if chkc then return chkc:IsOnField() and c101010207.filter(chkc) end
	if chk==0 then return Duel.IsExistingMatchingCard(c101010207.cfilter1,tp,LOCATION_MZONE,0,1,nil) and Duel.IsExistingTarget(c101010207.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,rc) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,c101010207.filter,tp,LOCATION_ONFIELD,LOCATION_ONFIELD,1,1,rc)
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function c101010207.cfilter1(c)
	return c:IsFaceup() and c:IsAttribute(ATTRIBUTE_WATER) and c:GetSummonLocation()==LOCATION_DECK and c:GetFlagEffect(101010207)==0
end
function c101010207.op1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and tc:IsFaceup() then
		if Duel.Destroy(tc,REASON_EFFECT)==0 then return end
		local atk=tc:GetTextAttack()
		if atk<0 then atk=0 end
		local c=e:GetHandler()
		local sg=Duel.SelectMatchingCard(tp,c101010207.cfilter1,tp,LOCATION_MZONE,0,1,1,nil)
		Duel.HintSelection(sg)
		local sc=sg:GetFirst()
		if not sc or sc:IsFacedown() then return end
		sc:RegisterFlagEffect(101010207,RESET_EVENT+0x1fe0000,EFFECT_FLAG_CANNOT_DISABLE,1)
		if tc:IsType(TYPE_MONSTER) then
			local e1=Effect.CreateEffect(c)
			e1:SetType(EFFECT_TYPE_SINGLE)
			e1:SetCode(EFFECT_UPDATE_ATTACK)
			e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e1:SetValue(atk/2)
			e1:SetReset(RESET_EVENT+0x1fe0000)
			sc:RegisterEffect(e1)
			elseif tc:IsType(TYPE_SPELL) then
			local e2=Effect.CreateEffect(c)
			e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
			e2:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e2:SetCode(EFFECT_DESTROY_REPLACE)
			e2:SetTarget(c101010207.indtg)
			e2:SetReset(RESET_EVENT+0x1fe0000)
			sc:RegisterEffect(e2)
			else
			local e3=Effect.CreateEffect(c)
			e3:SetType(EFFECT_TYPE_SINGLE)
			e3:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
			e3:SetCode(EFFECT_INDESTRUCTABLE_BATTLE)
			e3:SetValue(1)
			e3:SetReset(RESET_EVENT+0x1fe0000)
			sc:RegisterEffect(e3)
		end
	end
end
function c101010207.indtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsContains(e:GetHandler()) and r==REASON_EFFECT end
	return true
end