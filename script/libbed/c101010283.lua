--炯然ドラグーン
local id,ref=GIR()
function ref.start(c)
aux.AddSynchroProcedure(c,aux.FilterBoolFunction(Card.IsAttribute,ATTRIBUTE_LIGHT),aux.NonTuner(nil),1)
	--reveal
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetCountLimit(1)
	e1:SetCost(ref.cost)
	e1:SetOperation(ref.operation)
	c:RegisterEffect(e1)
	--Cost Change
	local e2=Effect.CreateEffect(c)
	e2:SetType(EFFECT_TYPE_FIELD)
	e2:SetCode(EFFECT_LPCOST_CHANGE)
	e2:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e2:SetRange(LOCATION_MZONE)
	e2:SetTargetRange(1,0)
	e2:SetValue(ref.value)
	c:RegisterEffect(e2)
end
function ref.cfilter(c)
	return c:IsSetCard(0x5e) and not c:IsPublic()
end
function ref.cost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(ref.cfilter,tp,LOCATION_HAND,0,1,nil) end
	local tc=Duel.SelectMatchingCard(tp,ref.cfilter,tp,LOCATION_HAND,0,1,1,nil):GetFirst()
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_IMMEDIATELY_APPLY)
	e1:SetCode(EFFECT_PUBLIC)
	e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
	tc:RegisterEffect(e1)
end
function ref.atkfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsFaceup()
end
function ref.operation(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(ref.atkfilter,e:GetHandler():GetControler(),LOCATION_MZONE,0,nil)
	local tc=g:GetFirst()
	while tc do
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE)
		e1:SetCode(EFFECT_UPDATE_ATTACK)
		e1:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
		e1:SetValue(400)
		e1:SetReset(RESET_EVENT+0x1fe0000+RESET_PHASE+PHASE_END)
		tc:RegisterEffect(e1)
		tc=g:GetNext()
	end
end
function ref.radfilter(c)
	return c:IsType(TYPE_MONSTER) and c:IsSetCard(0x5e) and c:IsPublic()
end
function ref.value(e,re,rp,val)
	if not Duel.IsExistingMatchingCard(ref.radfilter,e:GetHandlerPlayer(),LOCATION_HAND,0,1,nil) then return val end
	if re:IsHasType(EFFECT_TYPE_ACTIVATE) and bit.band(re:GetHandler():GetType(),TYPE_CONTINUOUS)==TYPE_CONTINUOUS then
		return 0
	elseif re:IsHasType(EFFECT_TYPE_CONTINUOUS) and bit.band(re:GetType(),EFFECT_TYPE_FIELD+EFFECT_TYPE_SINGLE)~=0 then
		return val/2
	else
		return val
	end
end