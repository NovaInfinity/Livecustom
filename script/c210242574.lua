--Blue Striker Beast: Moon Burst Clearing
function c210242574.initial_effect(c)
	aux.EnablePendulumAttribute(c,true)
	--Search
	local e1=Effect.CreateEffect(c)
	e1:SetDescription(aux.Stringid(4066,0))
	e1:SetCategory(CATEGORY_TOHAND+CATEGORY_SEARCH)
	e1:SetType(EFFECT_TYPE_IGNITION)
	e1:SetRange(LOCATION_HAND)
	e1:SetCost(c210242574.cost1)
	e1:SetTarget(c210242574.target1)
	e1:SetOperation(c210242574.operation1)
	c:RegisterEffect(e1)
	--Banish
	local e2=Effect.CreateEffect(c)
	e2:SetDescription(aux.Stringid(210242574,1))
	e2:SetCountLimit(1,210242573)
	e2:SetCategory(CATEGORY_REMOVE)
	e2:SetType(EFFECT_TYPE_SINGLE+EFFECT_TYPE_TRIGGER_O)
	e2:SetCode(EVENT_SPSUMMON_SUCCESS)
	e2:SetProperty(EFFECT_FLAG_CARD_TARGET+EFFECT_FLAG_DELAY)
	e2:SetCost(c210242574.descost1)
	e2:SetTarget(c210242574.destg1)
	e2:SetOperation(c210242574.desop1)
	c:RegisterEffect(e2)
	-- Once per turn: You can shuffle 1 "Blue Striker" monster you control into the Deck; 
	-- Special Summon 1 "Blue Striker" monster with a different name from your Deck.
	local e3=Effect.CreateEffect(c)
	e3:SetCategory(CATEGORY_TODECK+CATEGORY_SPECIAL_SUMMON)
	e3:SetType(EFFECT_TYPE_IGNITION)
	e3:SetRange(LOCATION_PZONE)
	e3:SetTarget(c210242574.tg)
	e3:SetOperation(c210242574.op)
	e3:SetCountLimit(1)
	c:RegisterEffect(e3)
end
--OPT, send a Striker you control to the deck, If you do, sp summon a different one from the deck.
function c210242574.filter1(c,e,tp)
	local code=c:GetCode()
	return c:IsFaceup() and c:IsSetCard(0x666) and c:IsAbleToDeckOrExtraAsCost()
		and Duel.IsExistingMatchingCard(c210242574.filter2,tp,LOCATION_DECK,0,1,nil,code,e,tp)
end
function c210242574.filter2(c,code,e,tp)
	return c:IsSetCard(0x666) and c:GetCode()~=code and c:IsCanBeSpecialSummoned(e,0,tp,false,false)
end
function c210242574.tg(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.GetLocationCount(tp,LOCATION_MZONE)>-1
		and Duel.IsExistingMatchingCard(c210242574.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp)
	end
	Duel.SetOperationInfo(0,CATEGORY_TODECK,rg,1,0,0)
	Duel.SetOperationInfo(0,CATEGORY_SPECIAL_SUMMON,nil,1,tp,LOCATION_DECK)
end
function c210242574.op(e,tp,eg,ep,ev,re,r,rp)
	if not e:GetHandler():IsRelateToEffect(e) or not Duel.IsExistingMatchingCard(c210242574.filter1,tp,LOCATION_MZONE,0,1,nil,e,tp) then return end
    	local rg=Duel.SelectMatchingCard(tp,c210242574.filter1,tp,LOCATION_MZONE,0,1,1,nil,e,tp)
    	local code=rg:GetFirst():GetCode()
   	if  Duel.SendtoDeck(rg,nil,2,REASON_EFFECT)>0 then
    		if Duel.GetLocationCount(tp,LOCATION_MZONE)<=0 then return end
    		Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_SPSUMMON)
    		local g=Duel.SelectMatchingCard(tp,c210242574.filter2,tp,LOCATION_DECK,0,1,1,nil,code,e,tp)
    		if g:GetCount()>0 then
        		Duel.SpecialSummon(g,0,tp,tp,false,false,POS_FACEUP)
    		end
	end
end
--Effect 1 (Search) Code
function c210242574.cost1(e,tp,eg,ep,ev,re,r,rp,chk)
	local c=e:GetHandler()
	if chk==0 then return c:IsAbleToGraveAsCost() and c:IsDiscardable() end
	Duel.SendtoGrave(c,REASON_COST+REASON_DISCARD)
end
function c210242574.filter3(c)
	return c:IsCode(210242564) and c:IsAbleToHand()
end
function c210242574.target1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return Duel.IsExistingMatchingCard(c210242574.filter3,tp,0x51,0,1,nil) end
	Duel.SetOperationInfo(0,CATEGORY_TOHAND,nil,1,tp,0x51)
end
function c210242574.operation1(e,tp,eg,ep,ev,re,r,rp,chk)
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_ATOHAND)
	local tg=Duel.SelectMatchingCard(tp,c210242574.filter3,tp,0x51,0,1,1,nil):GetFirst()
	if tg then
		Duel.SendtoHand(tg,nil,REASON_EFFECT)
		Duel.ConfirmCards(1-tp,tg)
	end
end
--Effect 2/3 (Banish code fuction)
function c210242574.descost1(e,tp,eg,ep,ev,re,r,rp,chk)
	if chk==0 then return e:GetHandler():IsReleasable() end
	Duel.Release(e:GetHandler(),REASON_COST)
end
function c210242574.destg1(e,tp,eg,ep,ev,re,r,rp,chk,chkc)
	if chkc then return chkc:IsLocation(LOCATION_MZONE) end
	if chk==0 then return Duel.IsExistingTarget(aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,nil) end
	Duel.Hint(HINT_SELECTMSG,tp,HINTMSG_REMOVE)
	local g=Duel.SelectTarget(tp,aux.TRUE,tp,LOCATION_MZONE,LOCATION_MZONE,1,1,nil)
	Duel.SetOperationInfo(0,CATEGORY_REMOVE,g,1,0,0)
end
function c210242574.desop1(e,tp,eg,ep,ev,re,r,rp)
	local tc=Duel.GetFirstTarget()
	if tc and tc:IsRelateToEffect(e) then
		Duel.Remove(tc,POS_FACEUP,REASON_EFFECT)
	end
end
