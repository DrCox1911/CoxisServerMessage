--[[
#########################################################################################################
#	@mod:		Coxisservermessage - Display those rules!                                                     #
#	@author: 	Dr_Cox1911					                                                                        #
#	@notes:		Many thanks to the PZ dev team and all the modders!                    	            				#
#	@notes:		For usage instructions check forum link below                                          			#
#	@link: 												       										#
#########################################################################################################
--]]

require 'CoxisUtil'

CoxisServerMessageClient = {};
CoxisServerMessageClient.debug = true;
CoxisServerMessageClient.luanet = nil;
CoxisServerMessageClient.module = nil;
CoxisServerMessageClient.rules = nil;

CoxisServerMessageClient.initMP = function()
  CoxisUtil.printDebug("CoxisServerMessageClient", "INIT MP");
  CoxisServerMessageClient.luanet = LuaNet:getInstance();
  CoxisServerMessageClient.module = CoxisServerMessageClient.luanet.getModule("CoxisServerMessage", CoxisServerMessageClient.debug);
  CoxisServerMessageClient.luanet.setDebug(CoxisServerMessageClient.debug);
  CoxisServerMessageClient.module.addCommandHandler("rules", CoxisServerMessageClient.receiveRules);
end

CoxisServerMessageClient.receiveRules = function(_player, _rules)
    local height, width;
    height = getCore():getScreenHeight()/2;
    width = getCore():getScreenWidth()/2;
    CoxisUtil.printDebug("CoxisServerMessageClient", "RECEIVED RULES");
    CoxisServerMessageClient.rules = _rules;
    CoxisUtil.printDebug("CoxisServerMessageClient", CoxisServerMessageClient.rules);
    CoxisUtil.okModal(CoxisServerMessageClient.rules, true, width, height);  -- #todo: change resolution of the window according to the screen size of the game
end

CoxisServerMessageClient.askRules = function(_tick)
  if _tick >= 3 then
    CoxisUtil.printDebug("CoxisServerMessageClient", "ASKING RULES");
    CoxisServerMessageClient.module.send("rules", getPlayer());
    Events.OnTick.Remove(CoxisServerMessageClient.askRules);
  end
end

CoxisServerMessageClient.init = function()
  CoxisUtil.printDebug("CoxisServerMessageClient", "INIT");
  if isClient() then
		LuaNet:getInstance().onInitAdd(CoxisServerMessageClient.initMP);
	end

end

Events.OnConnected.Add(CoxisServerMessageClient.init)
Events.OnTick.Add(CoxisServerMessageClient.askRules)
