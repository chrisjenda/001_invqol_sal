-- Based on the fantastic "Maek One Page Readable" mod by RH4DB4
-- https://steamcommunity.com/sharedfiles/filedetails/?id=1928908192&searchtext=read+one+page
-- TimedActions\ISReadABook.lua
local originalISReadABookUpdate = ISReadABook.update

function ISReadABook:update(...)

  local isrecipiebook = SkillBook[self.item:getSkillTrained()];
  if isrecipiebook == nil then
    return originalISReadABookUpdate(self, ...);
  end

  local learnable = self.item:getLvlSkillTrained() > self.character:getPerkLevel(isrecipiebook.perk) + 1;
  local isvalidSkillbook = self.item:getNumberOfPages() > 0 and SkillBook[self.item:getSkillTrained()];

	if isvalidSkillbook and learnable or self.character:HasTrait("Illiterate") then
			self.pageTimer = 0;
			local txtRandom = ZombRand(3);
			if txtRandom == 0 then
					self.character:Say(getText("I'll keep track of it."));
			elseif txtRandom == 1 then
					self.character:Say(getText("I'll be sure to remember that I've seen this one before."));
			else
					self.character:Say(getText("I've made a note of it."));
			end
			if self.item:getNumberOfPages() > 0 then
					self.character:setAlreadyReadPages(self.item:getFullType(), 1)
					self:forceStop()
			end
  elseif isvalidSkillbook and not learnable and self.character:getAlreadyReadPages(self.item:getFullType()) == 0 then
    -- This book has no pages read yet
    self.pageTimer = 0;
    if self.item:getNumberOfPages() > 0 then
        self.character:setAlreadyReadPages(self.item:getFullType(), 1)
        self:forceStop()
    end
	else
		return originalISReadABookUpdate(self, ...)
	end
end
