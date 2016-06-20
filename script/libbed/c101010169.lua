--ドミニオン・オヴ・ヴォイド
local id,ref=GIR()
function ref.start(c)
--Activate
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_SEARCH+CATEGORY_TOHAND)
	e0:SetType(EFFECT_TYPE_ACTIVATE)
	e0:SetCode(EVENT_FREE_CHAIN)
	e0:SetOperation(ref.op)
	c:RegisterEffect(e0)
	--grave seal
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetCode(EFFECT_CANNOT_REMOVE)
	e1:SetRange(LOCATION_FZONE)
	e1:SetTargetRange(LOCATION_GRAVE,LOCATION_GRAVE)
	e1:SetTarget(ref.rmtg)
	c:RegisterEffect(e1)
	local e3=Effect.CreateEffect(c)
	e3:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_CONTINUOUS)
	e3:SetCode(EFFECT_SEND_REPLACE)
	e3:SetRange(LOCATION_FZONE)
	e3:SetTarget(ref.rtarget)
	e3:SetValue(ref.rvalue)
	c:RegisterEffect(e3)
	--Atk up
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_SET_ATTACK)
	e2:SetRange(LOCATION_FZONE)
	e2:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
	e2:SetTarget(ref.atktg)
	e2:SetValue(ref.atkval)
	c:RegisterEffect(e2)
end
function ref.thfilter(c)
	return c:IsSetCard(0x5d) and c:IsType(TYPE_SPELL) and c:IsAbleToHand()
end
function ref.op(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local g=Duel.SelectMatchingCard(tp,ref.thfilter,tp,LOCATION_DECK,0,1,1,nil)
	if g:GetCount()>0 then Duel.SendtoHand(g,nil,REASON_EFFECT) Duel.ConfirmCards(1-tp,g) end
	-- g and
end
function ref.atktg(e,c)
	return c:IsAttribute(ATTRIBUTE_DARK)
end
function ref.atkval(e,c)
	local atk=c:GetBaseAttack()
	return atk*1.2
end
function ref.rmtg(e,c,sump,sumtype,sumpos,targetp)
	return not c:IsLocation(LOCATION_OVERLAY) and not c:IsType(TYPE_SPELL+TYPE_TRAP)
end
function ref.filter(c)
	return c:GetLocation()~=LOCATION_OVERLAY and not c:IsType(TYPE_SPELL+TYPE_TRAP) and c:GetDestination()==LOCATION_REMOVED
end
function ref.rtarget(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return eg:IsExists(ref.filter,1,nil) end
	local g=eg:Filter(ref.filter,nil)
	Duel.SendtoGrave(g,r)
end
function ref.rvalue(e,c)
	return ref.filter(c)
end