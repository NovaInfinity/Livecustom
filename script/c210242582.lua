--Blue Striker: Moon Burst Streamer
function c210242582.initial_effect(c)
	--pendulum summon
	aux.EnablePendulumAttribute(c)
	-- Once per turn: You can shuffle 1 "Blue Striker" monster you control into the Deck; 
	-- Special Summon 1 "Blue Striker" monster with a different name from your Deck.
	local e1=Effect.CreateEffect(c)
	e1:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_PZONE)
	e1:SetTarget(c210242582.tg)
	e1:SetOperation(c210242582.op)
	e1:SetCountLimit(1)
	c:RegisterEffect(e1)
	--Tiny Pony Search
	local e4=Effect.CreateEffect(c)
	e4:SetDescription(aux.Stringid(4066,0))
	e4:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e4:SetType(EFFECT_TYPE_IGNITION)
	e4:SetRange(LOCATION_HAND)
	e4:SetCost(c210242582.descon1)
	e4:SetTarget(c210242582.destg1)
	e4:SetOperation(c210242582.desop1)
	c:RegisterEffect(e4)
    	--Healing from extra
	local e5=Effect.CreateEffect(c)
	e5:SetDescription(aux.Stringid(210242582,4))
	e5:SetCategory(CATEGORY_RECOVER)
	e5:SetProperty(EFFECT_FLAG_DAMAGE_STEP+EFFECT_FLAG_DELAY)
	e5:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_F)
	e5:SetCode(EVENT_DESTROYED)
	e5:SetCondition(c210242582.dmcon)
	e5:SetTarget(c210242582.dmtg)
	e5:SetOperation(c210242582.dmop)
	c:RegisterEffect(e5)
end
--OPT, send a Striker you control to the deck, If you do, sp summon a different one from the deck.
function c210242582.filter1(c,e,tp)
	local code=c:GetCode()
	return c:IsFaceup() and c:IsSetCard(0x666) and c:IsAbleToDeckOrExtraAsCost()
		and Duel.IsExistingMatchingCard(c210242582.filter2,tp,LOCATION_DECK,0,1,nil,code,e,tp)
end
function c210242582.filter2(c,code,e,tp)
	return c:IsSetCard(0x666) and c:GetCode()~=code and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c210242582.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c210242582.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,rg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c210242582.op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or not Duel.IsExistingMatchingCard(c210242582.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) then return end
    	local rg=Duel.SelectMatchingCard(tp,c210242582.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
    	local code=rg:GetFirst():GetCode()
   	if  Duel.SendtoDeck(rg,nil,2,REASON_EFFECT)>0 then
    		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    		local g=Duel.SelectMatchingCard(tp,c210242582.filter2,tp,LOCATION_DECK,0,1,1,nil,code,e,tp)
    		if g:GetCount()>0 then
        		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    		end
	end
end
function c210242582.dmfilter(c)
	return c:IsSetCard(0x666) and c:IsType(TYPE_MONSTER) and c:IsLocation(LOCATION_GRAVE) or (c:IsSetCard(0x666) and c:IsLocation(LOCATION_EXTRA) and c:IsFaceup())
end
function c210242582.dmcon(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	return c:IsReason(REASON_DESTROY)
end
function c210242582.dmtg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c210242582.dmfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,1,nil) end
	local g=Duel.GetMatchingGroup(c210242582.dmfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,nil)
	local dam=g:GetClassCount(Card.GetCode)*200
	Duel.SetOperationInfo(0,CATAGORY_RECOVERY,nil,0,tp,dam)
end
function c210242582.dmop(e,tp,eg,ep,ev,re,r,rp)
	local c=e:GetHandler()
	local g=Duel.GetMatchingGroup(c210242582.dmfilter,tp,LOCATION_EXTRA+LOCATION_GRAVE,0,nil)
	local dam=g:GetClassCount(Card.GetCode)*200
	Duel.Recover(tp,dam,REASON_EFFECT)
end
--Effect 1 (Search) Code
function c210242582.descon1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c210242582.filter(c)
	return c:IsCode(210242564) and c:IsAbleToHand()
end
function c210242582.destg1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c210242582.filter,tp,0x51,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x51)
end
function c210242582.desop1(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,c210242582.filter,tp,0x51,0,1,1,nil):GetFirst()
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
