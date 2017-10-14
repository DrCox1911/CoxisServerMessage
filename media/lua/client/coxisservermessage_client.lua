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
  CoxisServerMessageClient.module.send("rules", getPlayer(), getPlayer():getUsername());
end

CoxisServerMessageClient.receiveRules = function(_player, _rules)
  CoxisUtil.printDebug("CoxisServerMessageClient", "RECEIVED RULES")
  CoxisServerMessageClient.rules = _rules;
end

CoxisServerMessageClient.init = function()
  CoxisUtil.printDebug("CoxisServerMessageClient", "INIT");
  if isClient() then
		LuaNet:getInstance().onInitAdd(CoxisServerMessageClient.initMP);
	end

end

Events.OnConnected.Add(CoxisServerMessageClient.init)
