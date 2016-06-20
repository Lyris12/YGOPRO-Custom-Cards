--Advance Sea Scout - Oreph of the Passing Tide
local id,ref=GIR()
function ref.start(c)
--synchro summon
	c:EnableReviveLimit()
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_FIELD)
	e0:SetCode(EFFECT_SPSUMMON_PROC)
	e0:SetProperty(EFFECT_FLAG_UNCOPYABLE+EFFECT_FLAG_IGNORE_IMMUNE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetCondition(ref.syncon)
	e0:SetOperation(ref.synop)
	e0:SetValue(SUMMON_TYPE_SYNCHRO)
	c:RegisterEffect(e0)
	--boost
	local ae2=Effect.CreateEffect(c)
	ae2:SetType(EFFECT_TYPE_FIELD)
	ae2:SetCode(EFFECT_UPDATE_ATTACK)
	ae2:SetRange(LOCATION_MZONE)
	ae2:SetTargetRange(LOCATION_MZONE,0)
	ae2:SetCondition(ref.atkcon)
	ae2:SetTarget(ref.syntg)
	ae2:SetValue(800)
	c:RegisterEffect(ae2)
	--revive
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_MZONE)
	e1:SetProperty(EFFECT_FLAG_CARD_TARGET)
	e1:SetCountLimit(1,101010229)
	e1:SetTarget(ref.tg)
	e1:SetOperation(ref.op)
	c:RegisterEffect(e1)
end
ref.tuner_filter=function(mc) return true end
ref.nontuner_filter=function(mc) return mc and mc:IsType(TYPE_SYNCHRO) end
ref.minntct=1
ref.maxntct=99
ref.sync=true
ref.dobtun=true
ref.dtmlt=true
--[[ref.synfilter1=function(c,syncard,lv,f1,f2,minct,maxc,g1,g2,g3)
	local tlv=c:GetSynchroLevel(syncard)
	if lv-tlv<=0 then return false end
	if c:IsHasEffect(EFFECT_HAND_SYNCHRO) then
		return g3:IsExists(ref.synfilter2,1,c,syncard,lv-tlv,f1,f2,c,minct,maxc,g2)
	else
		return g1:IsExists(ref.synfilter2,1,c,syncard,lv-tlv,f1,f2,c,minct,maxc,g2)
	end
end
ref.synfilter2=function(c,syncard,lv,f1,f2,tuner1,minct,maxc,g2)
	if (f1~=nil and (not f1 or not f1(tuner1) or not f1(c))) then return false end
	local tlv=c:GetSynchroLevel(syncard)
	if lv-tlv<=0 then return false end
	local nt=g2:Filter(ref.synfilter3,nil,f1,f2,tuner1,c)
	return nt:CheckWithSumEqual(Card.GetSynchroLevel,lv-tlv,minct,maxc,syncard)
end
ref.synfilter3=function(c,f1,f2,t1,t2) return (f1==nil or (f1 and f1(t1) and f1(t2))) and (f2(c)) end]]
function ref.matfilter1(c,syncard)
	return c:IsType(TYPE_TUNER) and (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsCanBeSynchroMaterial(syncard)
end
function ref.matfilter2(c,syncard)
	return (c:IsLocation(LOCATION_HAND) or c:IsFaceup()) and c:IsCanBeSynchroMaterial(syncard)
end
function ref.synfilter1(c,syncard,lv,f1,f2,minct,maxc,g1,g2,g3)
	local tlv=c:GetSynchroLevel(syncard)
	if lv-tlv<=0 then return false end
	if c:IsHasEffect(EFFECT_HAND_SYNCHRO) then
		return g3:IsExists(ref.synfilter2,1,c,syncard,lv-tlv,f1,f2,c,minct,maxc,g2)
	else
		return g1:IsExists(ref.synfilter2,1,c,syncard,lv-tlv,f1,f2,c,minct,maxc,g2)
	end
end
function ref.synfilter2(c,syncard,lv,f1,f2,tuner1,minct,maxc,g2)
	if (f1~=nil and (not f1 or not f1(tuner1) or not f1(c))) then return false end
	local tlv=c:GetSynchroLevel(syncard)
	if lv-tlv<=0 then return false end
	local nt=g2:Filter(ref.synfilter3,nil,f1,f2,tuner1,c)
	return nt:CheckWithSumEqual(Card.GetSynchroLevel,lv-tlv,minct,maxc,syncard)
end
function ref.synfilter3(c,f1,f2,t1,t2)
	return (f1==nil or (f1 and f1(t1) and f1(t2))) and (f2(c))
end
function ref.syncon(e,c,tuner,mg)
	if c==nil then return true end
	if Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)<-2 then return false end
	local g1=nil
	local g2=nil
	local g3=nil
	local f1=nil
	local f2=aux.FilterBoolFunction(Card.IsType,TYPE_SYNCHRO)
	local dg1=Duel.GetMatchingGroup(ref.matfilter1,c:GetControler(),LOCATION_MZONE,0,nil,c)
	local dg2=Duel.GetMatchingGroup(ref.matfilter2,c:GetControler(),LOCATION_MZONE,0,nil,c)
	local dg3=Duel.GetMatchingGroup(ref.matfilter1,c:GetControler(),LOCATION_MZONE+LOCATION_HAND,0,nil,c)
	if mg then
		local sg1=mg:Filter(ref.matfilter1,nil,c)
		local sg2=mg:Filter(ref.matfilter2,nil,c)
		local sg3=mg:Filter(ref.matfilter1,nil,c)
		g1=sg1
		g3=sg3
		g2=sg2:Filter(f2,nil)
	else
		g1=dg1
		g3=dg3
		g2=dg2:Filter(f2,nil)
	end
	local pe=Duel.IsPlayerAffectedByEffect(c:GetControler(),EFFECT_MUST_BE_SMATERIAL)
	local lv=c:GetLevel()
	if tuner then
		local tlv=tuner:GetSynchroLevel(c)
		if lv-tlv<=0 then return false end
		if not pe then
			return g2:IsExists(ref.synfilter2,1,tuner,c,lv-tlv,f1,f2,tuner,1,99,g2)
		else
			return ref.synfilter2(pe:GetOwner(),tuner,lv-tlv,f1,f2,tuner,1,99,g2)
		end
	end
	if not pe then
		return g1:IsExists(ref.synfilter1,1,nil,c,lv,f1,f2,1,99,g1,g2,g3)
	else
		return ref.synfilter1(pe:GetOwner(),c,lv,f1,f2,1,99,g1,g2,g3)
	end
end
function ref.synop(e,tp,eg,ep,ev,re,r,rp,c,tuner,mg)
	local ft=Duel.GetLocationCount(c:GetControler(),LOCATION_MZONE)
	local filct=-ft
	local minc=1
	if minc<filct then minc=filct end
	local g=Group.CreateGroup()
	local g1=nil
	local g2=nil
	local g3=nil
	local f1=nil
	local f2=aux.FilterBoolFunction(Card.IsType,TYPE_SYNCHRO)
	local dg1=Duel.GetMatchingGroup(ref.matfilter1,c:GetControler(),LOCATION_MZONE,0,nil,c)
	local dg2=Duel.GetMatchingGroup(ref.matfilter2,c:GetControler(),LOCATION_MZONE,0,nil,c)
	local dg3=Duel.GetMatchingGroup(ref.matfilter1,c:GetControler(),LOCATION_MZONE+LOCATION_HAND,0,nil,c)
	if mg then
		local sg1=mg:Filter(ref.matfilter1,nil,c)
		local sg2=mg:Filter(ref.matfilter2,nil,c)
		local sg3=mg:Filter(ref.matfilter1,nil,c)
		g1=sg1
		g3=sg3
		g2=sg2:Filter(f2,nil)
	else
		g1=dg1
		g3=dg3
		g2=dg2:Filter(f2,nil)
	end
	local pe=Duel.IsPlayerAffectedByEffect(c:GetControler(),EFFECT_MUST_BE_SMATERIAL)
	local lv=c:GetLevel()
	if tuner then
		g:AddCard(tuner)
		local lv1=tuner:GetSynchroLevel(c)
		Duel.Hint(HINT_SELECTMSG,c:GetControler(),HINTMSG_SMATERIAL)
		local tuner2=nil
		if not pe then
			local t2=g2:FilterSelect(c:GetControler(),ref.synfilter2,1,1,tuner,c,lv-lv1,f1,f2,tuner,minc,99,g2)
			tuner2=t2:GetFirst()
		else
			tuner2=pe:GetOwner()
			Group.FromCards(tuner2):Select(c:GetControler(),1,1,nil)
		end
		g:AddCard(tuner2)
		local lv2=tuner2:GetSynchroLevel(c)
		local nt=g2:Filter(ref.synfilter3,nil,f1,f2,tuner,tuner2)
		Duel.Hint(HINT_SELECTMSG,c:GetControler(),HINTMSG_SMATERIAL)
		local m3=nt:SelectWithSumEqual(c:GetControler(),Card.GetSynchroLevel,lv-lv1-lv2,minc,99,c)
		g:Merge(m3)
	else
		Duel.Hint(HINT_SELECTMSG,c:GetControler(),HINTMSG_SMATERIAL)
		local tuner1=nil
		if not pe then
			local t1=g1:FilterSelect(c:GetControler(),ref.synfilter1,1,1,nil,c,lv,f1,f2,minc,99,g1,g2,g3)
			tuner1=t1:GetFirst()
		else
			tuner1=pe:GetOwner()
			Group.FromCards(tuner1):Select(c:GetControler(),1,1,nil)
		end
		g:AddCard(tuner1)
		local lv1=tuner1:GetSynchroLevel(c)
		local t2=nil
		Duel.Hint(HINT_SELECTMSG,c:GetControler(),HINTMSG_SMATERIAL)
		if tuner1:IsHasEffect(EFFECT_HAND_SYNCHRO) then
			t2=g3:FilterSelect(c:GetControler(),ref.synfilter2,1,1,tuner1,c,lv-lv1,f1,f2,tuner1,minc,99,g2)
		else
			t2=g1:FilterSelect(c:GetControler(),ref.synfilter2,1,1,tuner1,c,lv-lv1,f1,f2,tuner1,minc,99,g2)
		end
		local tuner2=t2:GetFirst()
		g:AddCard(tuner2)
		local lv2=tuner2:GetSynchroLevel(c)
		local nt=g2:Filter(ref.synfilter3,nil,f1,f2,tuner1,tuner2)
		Duel.Hint(HINT_SELECTMSG,c:GetControler(),HINTMSG_SMATERIAL)
		local m3=nt:SelectWithSumEqual(c:GetControler(),Card.GetSynchroLevel,lv-lv1-lv2,minc,99,c)
		g:Merge(m3)
	end
	c:SetMaterial(g)
	Duel.SendtoGrave(g,REASON_MATERIAL+REASON_SYNCHRO)
end
function ref.cfilter(c)
	return c:IsFaceup() and c:IsSetCard(0x5ce)
end
function ref.atkcon(e,tp,eg,ep,ev,re,r,rp)
	return Duel.IsExistingMatchingCard(ref.cfilter,tp,LOCATION_MZONE,0,2,e:GetHandler())
end
function ref.syntg(e,c)
	return ref.cfilter(c)
end
function ref.spfilter(c,e,tp)
	return c:IsSetCard(0x5ce) and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function ref.tg(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsControler(tp) and chkc:IsLocation(LOCATION_GRAVE) and ref.spfilter(chkc,e,tp) end
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingTarget(ref.spfilter,tp,LOCATION_GRAVE,0,1,nil,e,tp) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
	local g=Duel.SelectTarget(tp,ref.spfilter,tp,LOCATION_GRAVE,0,1,1,nil,e,tp)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,g,g:GetCount(),0,0)
end
function ref.op(e,tp,eg,ep,ev,re,r,rp)
	local tg=Duel.GetFirstTarget()
	if tg:IsRelateToEffect(e) then
		Duel.SpecialSummon(tg,0,tp,tp,false,false,POS_FACEUP)
	end
end