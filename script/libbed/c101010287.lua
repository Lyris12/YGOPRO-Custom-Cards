--No.24 サイバー・ドラゴン・丸藤
local id,ref=GIR()
function ref.start(c)
--xyz summon
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,aux.FilterBoolFunction(Card.IsRace,RACE_MACHINE),5,3)
	--continuous effects
	local aa=Effect.CreateEffect(c)
	aa:SetType(EFFECT_TYPE_FIELD)
	aa:SetTarget(ref.addcon)
	aa:SetRange(LOCATION_MZONE)
	aa:SetTargetRange(LOCATION_MZONE,0)
	aa:SetCode(EFFECT_ADD_ATTRIBUTE)
	aa:SetValue(ATTRIBUTE_LIGHT)
	c:RegisterEffect(aa)
	local ar=Effect.CreateEffect(c)
	ar:SetType(EFFECT_TYPE_FIELD)
	ar:SetTarget(ref.addcon)
	ar:SetRange(LOCATION_GRAVE)
	ar:SetTargetRange(LOCATION_GRAVE,0)
	ar:SetCode(EFFECT_ADD_RACE)
	ar:SetValue(RACE_DRAGON)
	c:RegisterEffect(ar)
	local sd=Effect.CreateEffect(c)
	sd:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	sd:SetCode(EVENT_SPSUMMON_SUCCESS)
	sd:SetCondition(ref.sdcon)
	sd:SetOperation(ref.sdop)
	c:RegisterEffect(sd)
	local na=Effect.CreateEffect(c)
	na:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	na:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	na:SetCode(EVENT_SPSUMMON_SUCCESS)
	na:SetOperation(ref.limit)
	c:RegisterEffect(na)
	local cp=Effect.CreateEffect(c)
	cp:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	cp:SetCode(EVENT_ADJUST)
	cp:SetRange(LOCATION_MZONE)
	cp:SetCondition(ref.condition)
	cp:SetOperation(ref.copy)
	c:RegisterEffect(cp)
	--attach
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_F)
	e1:SetCode(EVENT_PHASE+PHASE_END)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCondition(ref.atcon)
	e1:SetOperation(ref.atop)
	c:RegisterEffect(e1)
	--detach
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101010016,0))
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_MZONE)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e2:SetCountLimit(1)
	e2:SetCondition(ref.condition)
	e2:SetCost(ref.cost)
	e2:SetTarget(ref.target)
	e2:SetOperation(ref.op)
	c:RegisterEffect(e2)
end
ref.xyz_number=24
function ref.addcon(e,c)
	return c==e:GetHandler()
end
function ref.sdcon(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetPreviousLocation()~=LOCATION_EXTRA
end
function ref.sdop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Destroy(e:GetHandler(),REASON_EFFECT)
end
function ref.atcon(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():GetFlagEffect(101010016)~=0 then return false end
	return e:GetHandler():GetOverlayCount()==0
end
function ref.atop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetFieldGroup(tp,LOCATION_EXTRA,LOCATION_EXTRA)
	if g:GetCount()>0 then
		local tc=g:RandomSelect(tp,1):GetFirst()
		Duel.Overlay(c,tc)
	end
end
function ref.indes(e,c)
	return not c:IsSetCard(0x48) or not c:IsSetCard(0x1048)
end
function ref.limit(e,tp,eg,ep,ev,re,r,rp)
	e:GetHandler():RegisterFlagEffect(101010016,RESET_EVENT+0xfc0000+RESET_PHASE+PHASE_END,0,1)
end
function ref.condition(e,tp,eg,ep,ev,re,r,rp)
	return e:GetHandler():GetFlagEffect(101010016)==0
end
function ref.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():CheckRemoveOverlayCard(tp,1,REASON_COST) end
	e:GetHandler():RemoveOverlayCard(tp,1,1,REASON_COST)
end
function ref.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and chkc:IsControler(1-tp) end
	if chk==0 then return Duel.IsExistingTarget(Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectTarget(tp,Card.IsAbleToRemove,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
	local atk=g:GetFirst():GetTextAttack()/2
	if atk<0 then atk=0 end
	Duel.SetOperationInfo(0,CATEGORY_DAMAGE,nil,0,1-tp,atk)
end
function ref.op(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsFacedown() then Duel.ConfirmCards(1-tp,tc) end
	if tc and tc:IsRelateToEffect(e) then
		local atk=tc:GetTextAttack()/2
		if atk<0 then atk=0 end
		Duel.Damage(1-tp,atk,REASON_BATTLE)
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
function ref.cpfilter(c)
	return (c:IsRace(RACE_MACHINE) or c:IsRace(RACE_DRAGON)) and (c:IsAttribute(ATTRIBUTE_LIGHT) or c:IsAttribute(ATTRIBUTE_DARK)) and not c:IsType(TYPE_TUNER)
end
function ref.copy(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local wg=Duel.GetMatchingGroup(ref.cpfilter,c:GetControler(),LOCATION_REMOVED,0,nil)
	local wbc=wg:GetFirst()
	while wbc do
		local code=wbc:GetOriginalCode()
		if c:IsFaceup() and c:GetFlagEffect(code)==0 then
			c:CopyEffect(code,RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END,1)
			c:RegisterFlagEffect(code,RESET_EVENT+0x1ff0000+RESET_PHASE+PHASE_END,0,1)
		end
		wbc=wg:GetNext()
	end
end