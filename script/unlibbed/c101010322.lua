--Action Card - Crysta Split
function c101010458.initial_effect(c)
	--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_ATKCHANGE+CATEGORY_DRAW)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c101010458.target)
	e1:SetOperation(c101010458.activate)
	c:RegisterEffect(e1)
end
function c101010458.filter(c)
	return c:IsFaceup() and c:IsSetCard(0x1613)
end
function c101010458.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) and chkc:IsControler(tp) and c101010458.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(c101010458.filter,tp,LOCATION_MZONE,0,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FACEUP)
	Duel.SelectTarget(tp,c101010458.filter,tp,LOCATION_MZONE,0,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_DRAW,nil,0,tp,1)
end
function c101010458.activate(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) and tc:IsFaceup() then
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_SET_ATTACK_FINAL)
		e1:SetReset(RESET_EVENT+0x1fe000)
		e1:SetValue(tc:GetAttack()/2)
		tc:RegisterEffect(e1)
		local e0=e1:Clone()
		e0:SetCode(EFFECT_SET_DEFENCE_FINAL)
		e0:SetValue(tc:GetDefence()/2)
		tc:RegisterEffect(e0)
		Duel.Draw(tp,1,REASON_EFFECT)
	end
end