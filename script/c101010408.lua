--F・HERO Light－9
local id,ref=GIR()
function ref.initial_effect(c)
	c:EnableReviveLimit()
	--set
	local e1=Effect.CreateEffect(c)
	e1:SetType(EFFECT_TYPE_SINGLE)
	e1:SetCode(EFFECT_MONSTER_SSET)
	e1:SetValue(TYPE_TRAP+TYPE_CONTINUOUS)
	c:RegisterEffect(e1)
	--activate
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(101010171,0))
	e2:SetType(EFFECT_TYPE_ACTIVATE+EFFECT_TYPE_QUICK_O)
	e2:SetCode(EVENT_FREE_CHAIN)
	e2:SetRange(LOCATION_SZONE)
	e2:SetLabel(1)
	e2:SetCondition(ref.actcon)
	e2:SetCost(ref.actcost)
	e2:SetOperation(ref.act)
	c:RegisterEffect(e2)
	local e6=e2:Clone()
	e6:SetDescription(aux.Stringid(101010171,1))
	e6:SetLabel(2)
	c:RegisterEffect(e6)
	--control
	local e4=Effect.CreateEffect(c)
	e4:SetCategory(CATEGORY_CONTROL)
	e4:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e4:SetCode(EVENT_SPSUMMON_SUCCESS)
	e4:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e4:SetTarget(ref.target)
	e4:SetOperation(ref.operation)
	c:RegisterEffect(e4)
	--destroy
	local e5=Effect.CreateEffect(c)
	e5:SetCategory(CATEGORY_DESTROY+CATEGORY_DAMAGE)
	e5:SetType(EFFECT_TYPE_FIELD+EFFECT_TYPE_TRIGGER_O)
	e5:SetCode(EVENT_PHASE+PHASE_END)
	e5:SetCountLimit(1)
	e5:SetRange(LOCATION_MZONE)
	e5:SetTarget(ref.destg)
	e5:SetOperation(ref.desop)
	c:RegisterEffect(e5)
end
function ref.mat_filter(c)
	return c:GetLevel()~=8
end
function ref.actcon(e,tp,eg,ep,ev,re,r,rp)
	return not e:GetHandler():IsStatus(STATUS_SET_TURN) or e:GetHandler():GetFlagEffect(101010170)~=0
end
function ref.bfilter(c,opt)
	if not c:IsAbleToRemoveAsCost() then return false end
	if opt==1 then
		return c:IsSetCard(0x9008) and c:IsType(TYPE_MONSTER) and Duel.IsExistingMatchingCard(ref.dsfilter,tp,LOCATION_HAND,0,1,nil)
	elseif opt==2 then
		return c:IsSetCard(0xc008) and c:IsType(TYPE_MONSTER)
	else return false
	end
end
function ref.dsfilter(c)
	return c:IsSetCard(0x9008) and c:IsType(TYPE_MONSTER) and c:IsDiscardable()
end
function ref.actcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(ref.bfilter,tp,LOCATION_GRAVE,0,1,nil,e:GetLabel()) end
	local g=Duel.SelectMatchingCard(tp,ref.bfilter,tp,LOCATION_GRAVE,0,1,1,nil,e:GetLabel())
	if e:GetLabel()==1 then
		Duel.DiscardHand(tp,ref.dsfilter,1,1,REASON_COST,nil)
	end
	Duel.Remove(g,POS_FACEUP,REASON_COST)
end
function ref.act(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if not c:IsRelateToEffect(e) then return end
	c:CancelToGrave()
	if ev~=0 then
		local ef=Duel.GetChainInfo(ev,CHAININFO_TRIGGERING_EFFECT)
		if ef~=nil and (ef:GetHandler():IsType(TYPE_EFFECT) or bit.band(c:GetOriginalType(),TYPE_EFFECT)==TYPE_EFFECT) and ef:GetHandler():IsLocation(LOCATION_MZONE) then Duel.NegateEffect(ev) end
		--disable
		local e3=Effect.CreateEffect(c)
		e3:SetType(EFFECT_TYPE_FIELD)
		e3:SetRange(LOCATION_SZONE)
		e3:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e3:SetTargetRange(LOCATION_MZONE,LOCATION_MZONE)
		e3:SetTarget(ref.disable)
		e3:SetCode(EFFECT_DISABLE)
		c:RegisterEffect(e3)
		--special summon
		local e0=Effect.CreateEffect(c)
		e0:SetCategory(CATEGORY_SPECIAL_SUMMON)
		e0:SetType(EFFECT_TYPE_IGNITION)
		e0:SetRange(LOCATION_SZONE)
		e0:SetProperty(EFFECT_FLAG_SINGLE_RANGE)
		e0:SetCost(ref.spcost)
		e0:SetTarget(ref.sptg)
		e0:SetOperation(ref.spop)
		c:RegisterEffect(e0)
	end
end
function ref.disable(e,c)
	return c:IsType(TYPE_EFFECT) or bit.band(c:GetOriginalType(),TYPE_EFFECT)==TYPE_EFFECT
end
function ref.cfilter(c)
	local s=0xc008
	if c:IsSetCard(0xc008) or c:IsSetCard(0x9008) then
		if c:IsSetCard(0x9008) then s=0x9008 end
		else return false
	end
	return c:IsReleasableByEffect() and ((c:IsLocation(LOCATION_MZONE) and Duel.CheckReleaseGroup(tp,ref.spfilter,2,c,s)) or (c:IsCode(101010176) and c:IsHasEffect(101010176)))
end
function ref.spfilter(c,s)
	return c:IsSetCard(s)
end
function ref.spcost(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(ref.cfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,nil) end
	local g1=Duel.SelectMatchingCard(tp,ref.cfilter,tp,LOCATION_MZONE+LOCATION_HAND,0,1,1,nil)
	local tc=g1:GetFirst()
	local s=0xc008
	if tc:IsSetCard(0x9008) then s=0x9008 end
	if (tc:IsCode(101010176) and tc:IsHasEffect(101010176)) then Duel.Release(tc,REASON_COST) return end
	local g2=Duel.SelectReleaseGroup(tp,ref.spfilter,2,2,tc,s)
	g1:Merge(g2)
	Duel.HintSelection(g1)
	Duel.Release(g1,REASON_COST)
end
function ref.sptg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-3
		and e:GetHandler():IsCanBeSpecialSummoned(e,SUMMON_TYPE_RITUAL,tp,false,true) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,e:GetHandler(),1,0,0)
end
function ref.spop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if c:IsRelateToEffect(e) then
		Duel.SpecialSummon(c,SUMMON_TYPE_RITUAL,tp,tp,false,true,POS_FACEUP)
		c:CompleteProcedure()
		c:TrapMonsterBlock()
	end
end
function ref.filter(c)
	return bit.band(c:GetSummonType(),SUMMON_TYPE_SPECIAL)==SUMMON_TYPE_SPECIAL and c:IsControlerCanBeChanged()
end
function ref.target(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:GetLocation()==LOCATION_MZONE and chkc:GetControler()~=tp and ref.filter(chkc) end
	if chk==0 then return Duel.IsExistingTarget(ref.filter,tp,0,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_CONTROL)
	local g=Duel.SelectTarget(tp,ref.filter,tp,0,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_CONTROL,g,1,0,0)
end
function ref.operation(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc:IsRelateToEffect(e) and not Duel.GetControl(tc,tp) then
		if not tc:IsImmuneToEffect(e) and tc:IsAbleToChangeControler() then
			Duel.Destroy(tc,REASON_EFFECT)
		end
	end
end
function ref.dfilter(c)
	return c:IsFaceup() and c:IsDestructable() and not c:IsSetCard(0x9008) and not c:IsSetCard(0xc008)
end
function ref.destg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(ref.dfilter,tp,LOCATION_MZONE,0,1,e:GetHandler()) end
	local g=Duel.GetMatchingGroup(ref.dfilter,tp,LOCATION_MZONE,0,e:GetHandler())
	Duel.SetOperationInfo(0,CATEGORY_DESTROY,g,1,0,0)
end
function ref.desop(e,tp,eg,ep,ev,re,r,rp)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_DESTROY)
	local g=Duel.SelectMatchingCard(tp,ref.dfilter,tp,LOCATION_MZONE,0,1,1,e:GetHandler())
	if g:GetCount()>0 then
		Duel.HintSelection(g)
		Duel.Destroy(g,REASON_EFFECT)
		Duel.BreakEffect()
		local atk=g:GetFirst():GetBaseAttack()
		if atk<0 then atk=0 end
		Duel.Damage(1-tp,atk,REASON_EFFECT)
	end
end