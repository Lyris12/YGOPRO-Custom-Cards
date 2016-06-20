--サイバー・スペース・エクシーズ・ドラゴン
function c101010343.initial_effect(c)
	c:EnableReviveLimit()
	aux.AddXyzProcedure(c,c101010343.xyzfilter,7,3,c101010343.ovfilter,aux.Stringid(101010343,2),3)
	c:SetSPSummonOnce(101010343)
	local e6=Effect.CreateEffect(c)
	e6:SetType(EFFECT_TYPE_SINGLE)
	e6:SetProperty(EFFECT_FLAG_CANNOT_DISABLE)
	e6:SetCode(EFFECT_ADD_ATTRIBUTE)
	e6:SetValue(ATTRIBUTE_DARK)
	c:RegisterEffect(e6)
	--sp condition
	local e0=Effect.CreateEffect(c)
	e0:SetType(EFFECT_TYPE_SINGLE)
	e0:SetCode(EFFECT_SPSUMMON_CONDITION)
	e0:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	e0:SetRange(LOCATION_EXTRA)
	e0:SetValue(c101010343.spslimit)
	c:RegisterEffect(e0)
	--fusion summon
	local fm=Effect.CreateEffect(c)
	fm:SetType(EFFECT_TYPE_SINGLE)
	fm:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	fm:SetCode(EFFECT_FUSION_MATERIAL)
	fm:SetCondition(c101010343.fmcon)
	fm:SetOperation(c101010343.fmatl)
	c:RegisterEffect(fm)
	local fs=Effect.CreateEffect(c)
	fs:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_CONTINUOUS)
	fs:SetProperty(EFFECT_FLAG_CANNOT_DISABLE+EFFECT_FLAG_UNCOPYABLE)
	fs:SetCode(EVENT_SPSUMMON_SUCCESS)
	fs:SetOperation(c101010343.fop)
	c:RegisterEffect(fs)
	local fus=Effect.CreateEffect(c)
	fus:SetDescription(aux.Stringid(101010343,1))
	fus:SetType(EFFECT_TYPE_FIELD)
	fus:SetCode(EFFECT_SPSUMMON_PROC)
	fus:SetProperty(EFFECT_FLAG_UNCOPYABLE)
	fus:SetRange(LOCATION_EXTRA)
	fus:SetCondition(c101010343.sprcon)
	fus:SetOperation(c101010343.sprop)
	fus:SetValue(SUMMON_TYPE_FUSION)
	c:RegisterEffect(fus)
	--banish
	local e0=Effect.CreateEffect(c)
	e0:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e0:SetType(EFFECT_TYPE_TRIGGER_F+EFFECT_TYPE_FIELD)
	e0:SetRange(0xbf)
	e0:SetCode(EVENT_SPSUMMON_SUCCESS)
	e0:SetCountLimit(1,101010343)
	e0:SetCondition(c101010343.con1)
	e0:SetTarget(c101010343.target)
	e0:SetOperation(c101010343.op1)
	c:RegisterEffect(e0)
end
c101010343.material_count=2
c101010343.material={86686671,12670770}
function c101010343.code(c)
	return c:IsFusionCode(70095154) or c:IsFusionCode(101010331)
end
function c101010343.spslimit(e,se,sp,st)
	return bit.band(st,SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION or bit.band(st,SUMMON_TYPE_XYZ)==SUMMON_TYPE_XYZ
end
function c101010343.xyzfilter(c)
	return c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_MACHINE)
end
function c101010343.ovfilter(c,tc)
	return c:IsFaceup() and c:IsRankAbove(5) and c101010343.xyzfilter(c) and c:GetCode()~=101010343
end
function c101010343.ovop(e,tp,chk)
	if chk==0 then return true end
	local c=e:GetHandler()
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	local mg=Duel.SelectMatchingCard(tp,aux.XyzAlterFilter,tp,LOCATION_MZONE,0,1,1,nil,c101010343.ovfilter,c)
	local mg2=mg:GetFirst():GetOverlayGroup()
	if mg2:GetCount()~=0 then
		local tc=mg2:GetFirst()
		while tc do
			mg:AddCard(tc)
			tc=mg2:GetNext()
		end
	end
	c:SetMaterial(mg)
	Duel.Overlay(c,mg)
	return
end
function c101010343.ffilter(c)
	local code=c:GetCode()
	return code==86686671 or code==12670770
end
function c101010343.fmcon(e,g,gc,chkf)
	if g==nil then return true end
	local loc1=LOCATION_SZONE
	local loc2=LOCATION_SZONE
	if not g:Filter(Card.IsControler,nil,e:GetHandlerPlayer()):IsExists(Card.IsOnField,1,nil) then loc1=0 end
	if not g:Filter(Card.IsControler,nil,1-e:GetHandlerPlayer()):IsExists(Card.IsOnField,1,nil) then loc2=0 end
	local mc=g:GetFirst()
	while mc do
		local lct=mc:GetLocation()
		local p=mc:GetControler()
		if p==e:GetHandlerPlayer() then loc1=bit.bor(loc1,lct) else loc2=bit.bor(loc2,lct) end
		mc=g:GetNext()
	end
	local sg=Duel.GetMatchingGroup(c101010343.ffilter,e:GetHandlerPlayer(),loc1,loc2,nil)
	local mg=g:Filter(Card.IsCanBeFusionMaterial,nil,e:GetHandler())
	mg:Merge(sg)
	if gc then
		if not gc:IsCanBeFusionMaterial(e:GetHandler()) then return false end
		local b1=0 local b2=0 local b3=0
		local tc=mg:GetFirst()
		while tc do
			if tc:IsFusionCode(70095154) or tc:IsFusionCode(101010331) then b1=1
			elseif tc:GetCode()==86686671 then b2=1
			elseif tc:GetCode()==12670770 then b3=1
			end
			tc=mg:GetNext()
		end
		if gc:IsFusionCode(70095154) or gc:IsFusionCode(101010331) then b1=1
		elseif gc:GetCode()==86686671 then b2=1
		elseif gc:GetCode()==12670770 then b3=1
		else return false
		end
		return b1+b2+b3>2
	end
	local b1=0 local b2=0 local b3=0
	local fs=false
	local tc=mg:GetFirst()
	while tc do
		if tc:IsFusionCode(70095154) or tc:IsFusionCode(101010331) then b1=1 if aux.FConditionCheckF(tc,chkf) then fs=true end
		elseif tc:GetCode()==86686671 then b2=1 if aux.FConditionCheckF(tc,chkf) then fs=true end
		elseif tc:GetCode()==12670770 then b3=1 if aux.FConditionCheckF(tc,chkf) then fs=true end
		end
		tc=mg:GetNext()
	end
	return b1+b2+b3>=3 and (fs or chkf==PLAYER_NONE)
end
function c101010343.fsfilter(c)
	local code=c:GetCode()
	return (c:IsFusionCode(70095154) or c:IsFusionCode(101010331)) or code==86686671 or code==12670770
end
function c101010343.fmatl(e,tp,eg,ep,ev,re,r,rp,gc,chkf)
	local loc1=LOCATION_SZONE
	local loc2=LOCATION_SZONE
	if not eg:Filter(Card.IsControler,nil,tp):IsExists(Card.IsOnField,1,nil) then loc1=0 end
	if not eg:Filter(Card.IsControler,nil,1-tp):IsExists(Card.IsOnField,1,nil) then loc2=0 end
	local mc=eg:GetFirst()
	while mc do
		local lct=mc:GetLocation()
		local tlc=bit.band(loc1,lct)
		if tlc==0 then
			local p=mc:GetControler()
			if p==e:GetHandlerPlayer() then loc1=bit.bor(loc1,lct) else loc2=bit.bor(loc2,lct) end
		end
		mc=eg:GetNext()
	end
	local mg=Duel.GetMatchingGroup(c101010343.ffilter,e:GetHandlerPlayer(),loc1,loc2,nil)
	local g=eg:Filter(Card.IsCanBeFusionMaterial,nil,e:GetHandler())
	g:Merge(mg)
	if gc then
		local sg=g:Filter(c101010343.fsfilter,gc)
		if c101010343.code(gc) then sg:Remove(c101010343.code,nil) else  sg:Remove(Card.IsCode,nil,gc:GetCode()) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local g1=sg:Select(tp,1,1,nil)
		if c101010343.code(g1:GetFirst()) then sg:Remove(c101010343.code,nil) else sg:Remove(Card.IsCode,nil,g1:GetFirst():GetCode()) end
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
		local g2=sg:Select(tp,1,1,nil)
		g1:Merge(g2)
		Duel.SetFusionMaterial(g1)
		return
	end
	local sg=g:Filter(c101010343.fsfilter,nil)
	local g1=nil
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	if chkf~=PLAYER_NONE then g1=sg:FilterSelect(tp,aux.FConditionCheckF,1,1,nil,chkf)
	else g1=sg:Select(tp,1,1,nil) end
	if c101010343.code(g1:GetFirst()) then sg:Remove(c101010343.code,nil) else sg:Remove(Card.IsCode,nil,g1:GetFirst():GetCode()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g2=sg:Select(tp,1,1,nil)
	if c101010343.code(g2:GetFirst()) then sg:Remove(c101010343.code,nil) else sg:Remove(Card.IsCode,nil,g2:GetFirst():GetCode()) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_FMATERIAL)
	local g3=sg:Select(tp,1,1,nil)
	g1:Merge(g2)
	g1:Merge(g3)
	Duel.SetFusionMaterial(g1)
end
function c101010343.olcheck(c)
	return c:GetOverlayCount()>0
end
function c101010343.fop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	if bit.band(c:GetSummonType(),SUMMON_TYPE_FUSION)==SUMMON_TYPE_FUSION then
		local g=c:GetMaterial()
		local ck=false
		if g:IsExists(Card.IsLocation,1,nil,LOCATION_HAND) then ck=true end
		local og=g:Filter(c101010343.olcheck,nil)
		local tc=og:GetFirst()
		if tc then Duel.SendtoGrave(tc:GetOverlayGroup(),REASON_RULE) end
		Duel.Overlay(c,g)
		if ck then Duel.ShuffleHand(tp) end
	end
end
function c101010343.fdfilter(c)
	return c:IsLocation(LOCATION_SZONE) and c:IsFacedown()
end
function c101010343.sprfilter(c,tc)
	local code=c:GetCode()
	return ((code==70095154 or code==101010331) and c:IsCanBeXyzMaterial(tc)) or code==86686671 or code==12670770
end
function c101010343.sprcon(e,c)
	if c==nil then return true end
	local tp=c:GetControler()
	local g=Duel.GetMatchingGroup(c101010343.sprfilter,tp,LOCATION_HAND+LOCATION_ONFIELD,0,nil,e:GetHandler())
	return Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and g:IsExists(c101010343.code,1,nil)
		and g:IsExists(Card.IsCode,1,nil,86686671)
		and g:IsExists(Card.IsCode,1,nil,12670770)
end
function c101010343.filter(c)
	return c:IsLocation(LOCATION_HAND) or (c:IsOnField() and c:IsFacedown())
end
function c101010343.sprop(e,tp,eg,ep,ev,re,r,rp)
	local g=Duel.GetMatchingGroup(c101010343.sprfilter,tp,LOCATION_ONFIELD+LOCATION_HAND,0,nil)
	local ft=Duel.GetLocationCount(tp,LOCATION_MZONE)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
	if ft<=0 then g1=g:FilterSelect(tp,Card.IsLocation,1,1,nil,LOCATION_MZONE)
	else g1=g:Select(tp,1,1,nil) end
	if c101010343.code(g1:GetFirst()) then g:Remove(c101010343.code,nil) else g:Remove(Card.IsCode,nil,g1:GetFirst():GetCode()) end
	for i=1,2 do
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		local g2=g:Select(tp,1,1,nil)
		if c101010343.code(g2:GetFirst()) then g:Remove(c101010343.code,nil) else g:Remove(Card.IsCode,nil,g2:GetFirst():GetCode()) end
		g1:Merge(g2)
	end
	local cg=g1:Filter(c101010343.filter,nil)
	if cg:GetCount()>0 then Duel.ConfirmCards(1-tp,cg) Duel.ShuffleHand(tp) end
	e:GetHandler():SetMaterial(g1)
end
function c101010343.cfilter(c)
	return c:IsFaceup() and c:IsLevelAbove(5)
end
function c101010343.xfilter(c)
	local code=c:GetCode()
	return ((code==70095154 or code==101010331) and c:IsCanBeXyzMaterial(c,true)) or code==86686671 or code==12670770
end
function c101010343.con1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return eg:IsExists(c101010343.cfilter,1,nil)
		and Duel.GetFieldGroupCount(tp,LOCATION_MZONE,0)==0
		and Duel.GetMatchingGroup(c101010343.xfilter,tp,LOCATION_HAND,0,nil):GetClassCount(Card.GetCode)>1
end
function c101010343.spfilter(c,e,tp)
	return c:IsType(TYPE_XYZ) and c:IsAttribute(ATTRIBUTE_LIGHT) and c:IsRace(RACE_MACHINE) and c:IsCanBeSpecialSummoned(e,SUMMON_TYPE_XYZ,tp,false,false) and c:GetCode()~=101010343
end
function c101010343.target(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToDeck() and Duel.GetLocationCount(tp,LOCATION_MZONE)>0
		and Duel.IsExistingMatchingCard(c101010343.spfilter,tp,LOCATION_EXTRA,0,1,nil,e,tp) end
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_EXTRA)
	Duel.SetOperationInfo(0,CATEGORY_TODECK,c,1,0,0)
end
function c101010343.op1(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c101010343.xfilter,tp,LOCATION_HAND,0,nil)
	local sg=Duel.GetMatchingGroup(c101010343.spfilter,tp,LOCATION_EXTRA,0,nil,e,tp)
	local xg=Group.CreateGroup()
	local xg1=nil
	local xg2=nil
	local cc=2
	while g:GetClassCount(Card.GetCode)>0 do
		local cg=g:GetClassCount(Card.GetCode)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
		xg1=g:Select(tp,1,1,nil)
		xg:AddCard(xg1:GetFirst())
		cc=cc-1
		g:Remove(Card.IsCode,nil,xg1:GetFirst():GetCode())
		if g:GetCount()>0 and cc==0 and Duel.SelectYesNo(tp,aux.Stringid(101010343,7)) then
			Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_XMATERIAL)
			xg2=g:Select(tp,1,1,nil)
			xg:AddCard(xg2:GetFirst())
		end
	end
	if sg:GetCount()>0 and xg:GetCount()>0 then
		Duel.ConfirmCards(1-tp,xg)
		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
		local xyz=sg:Select(tp,1,1,nil):GetFirst()
		Duel.Overlay(xyz,xg)
		Duel.SpecialSummon(xyz,SUMMON_TYPE_XYZ,tp,tp,false,false,POS_FACEUP)
		Duel.ShuffleHand(tp)
	end
	Duel.SendtoDeck(c,nil,0,REASON_EFFECT)
end