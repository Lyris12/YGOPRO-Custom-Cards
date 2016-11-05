--黒輪・コネクション
function c101010170.initial_effect(c)
--Activate
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_ACTIVATE)
	e1:SetCode(EVENT_FREE_CHAIN)
	e1:SetTarget(c101010170.target)
	e1:SetOperation(c101010170.activate)
	c:RegisterEffect(e1)
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e0:SetCode(EFFECT_ADD_TYPE)
	e0:SetValue(c101010170.monval)
	c:RegisterEffect(e0)
end
function c101010170.monval(e,c)
	if (c:IsOnField() and c:IsFacedown()) or c:IsLocation(LOCATION_GRAVE) then
		return TYPE_EFFECT+TYPE_MONSTER
	else
		return 0
	end
end
function c101010170.filter1(c,e)
	return c:IsCanBeFusionMaterial() and not c:IsImmuneToEffect(e)
end
function c101010170.filter2(c,e,tp,m,gc,chkf)
	return c:IsType(TYPE_FUSION) and c:IsRace(RACE_MACHINE) and (c:IsAttribute(ATTRIBUTE_DARK) or c:IsSetCard(0x5d))
		and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_FUSION,tp,false,false) and c:CheckFusionMaterial(m,gc,chkf)
end
function c101010170.target(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then
		local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
		local mg=Duel.GetMatchingGroup(Card.IsCanBeFusionMaterial,tp,LOCATION_MZONE,0,nil)
		return Duel.IsExistingMatchingCard(c101010170.filter2,tp,LOCATION_EXTRA,0,1,nil,e,tp,mg,e:GetHandler(),chkf)
	end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
end
function c101010170.activate(e,tp,eg,ep,ev,re,r,rp)
	if e:GetHandler():IsImmuneToEffect(e) then return end
	local chkf=Duel.GetLocationCount(tp,LOCATION_MZONE)>0 and PLAYER_NONE or tp
	local mg=Duel.GetMatchingGroup(c101010170.filter1,tp,LOCATION_MZONE,0,nil,e)
	local sg=Duel.GetMatchingGroup(c101010170.filter2,tp,LOCATION_EXTRA,0,nil,e,tp,mg,e:GetHandler(),chkf)
	if sg:GetCount()>0 then
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local tg=sg:Select(tp,1,1,nil)
		local tc=tg:GetFirst()
		local mat1=Duel.SelectFusionMaterial(tp,tc,mg,e:GetHandler(),chkf)
		tc:SetMaterial(mat1)
		Duel.SendtoGrave(mat1,REASON_EFFECT+REASON_MATERIAL+REASON_FUSION)
		Duel.BreakEffect()
		Duel.SpecialSummon(tc,SUMMON_TYPE_FUSION,tp,tp,false,false,POS_FACEUP)
		tc:CompleteProcedure()
		local e1=Effect.CreateEffect(e:GetHandler())
		e1:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
		e1:SetCode(EVENT_ATTACK_ANNOUNCE)
		e1:SetCondition(c101010170.atkcon)
		e1:SetOperation(c101010170.atkop)
		e1:SetReset(RESET_EVENT+0x1fe0000)
		tc:RegisterEffect(e1)
	end
	Duel.Remove(e:GetHandler(),POS_FACEUP,REASON_EFFECT)
end
function c101010170.atkcon(e)
	return (Duel.GetAttacker()==e:GetHandler() and Duel.GetAttackTarget()~=nil) and Duel.IsExistingMatchingCard(Card.IsCode,e:GetHandler():GetControler(),LOCATION_REMOVED,0,1,nil,101010170)
end
function c101010170.atkop(e,tp,eg,ep,ev,re,r,rp)
	local e1=Effect.CreateEffect(e:GetHandler())
	e1:SetType(EFFECT_TYPE_FIELD)
	e1:SetProperty(EFFECT_FLAG_PLAYER_TARGET)
	e1:SetCode(EFFECT_CANNOT_ACTIVATE)
	e1:SetTargetRange(0,1)
	e1:SetValue(c101010170.aclimit)
	e1:SetReset(RESET_PHASE+PHASE_DAMAGE)
	Duel.RegisterEffect(e1,tp)
end
function c101010170.aclimit(e,re,tp)
	return re:IsHasType(EFFECT_TYPE_ACTIVATE)
end