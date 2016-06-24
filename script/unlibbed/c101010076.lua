--Crystapal Lyris the Emerald
function c101010432.initial_effect(c)
	aux.EnablePendulumAttribute(c)
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e1:SetRange(LOCATION_PZONE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e1:SetCode(EVENT_TO_HAND)
	e1:SetOperation(c101010432.spcon)
	c:RegisterEffect(e1)
	local e2=Effect.CreateEffect(c)
	e2:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(101010432)
	e2:SetLabelObject(e1)
	e2:SetProperty(EFFECT_FLAG_DELAY+EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_EVENT_PLAYER)
	e2:SetTarget(c101010432.sumtg)
	e2:SetOperation(c101010432.sumop)
	c:RegisterEffect(e2)
end
function c101010432.cfilter(c)
	return not c:IsReason(REASON_DRAW) and c:IsType(TYPE_SPELL)
end
function c101010432.spcon(e,tp,eg,ep,ev,re,r,rp)
	e:SetLabelObject(eg)
	local c=e:GetHandler()
	local tc=eg:GetFirst()
	local tp1=false local tp2=false
	while tc do
		if c101010432.cfilter(tc) then
			if tc:IsControler(tp) then tp1=true else tp2=true end
		end
		tc=eg:GetNext()
	end
	if tp1 then Duel.RaiseSingleEvent(c,101010432,e,r,rp,tp,0) end
	if tp2 then Duel.RaiseSingleEvent(c,101010432,e,r,rp,1-tp,0) end
end
function c101010432.filter(c,e,tp)
	return c:IsSetCard(0x1613) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c101010432.sumtg(e,tp,eg,ep,ev,re,r,rp,chk)
	local p=e:GetHandler():GetControler()
	if chk==0 then return e:GetHandler():IsRelateToEffect(e) and not e:GetHandler():IsStatus(STATUS_CHAINING)
		and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101010432.filter,p,LOCATION_DECK,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c101010432.sumop(e,tp,eg,ep,ev,re,r,rp)
	local mg=e:GetLabelObject():GetLabelObject():Filter(c101010432.cfilter,nil,tp)
	local p=e:GetHandler():GetControler()
	local sg=Duel.GetMatchingGroup(c101010432.filter,p,LOCATION_DECK,0,nil,e,tp)
	local ft1=Duel.GetLocationCount(tp,LOCATION_MZONE)
	if ft1>0 and mg:GetCount()>0 then
		local g=mg:FilterSelect(tp,Card.IsControler,1,ft1,nil,tp)
		local sg1=sg:RandomSelect(tp,g:GetCount())
		Duel.SpecialSummon(sg1,0,tp,tp,false,false,POS_FACEUP)
	end
end