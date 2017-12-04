
require 'CoxisUtil'

CoxisServerMessageServer = {};
CoxisServerMessageServer.debug = true;
CoxisServerMessageServer.luanet = nil;
CoxisServerMessageServer.module = nil;
CoxisServerMessageServer.rules = "ERROR_WHILE_READING_IN_THE_RULES_ON_THE_SERVER!";

CoxisServerMessageServer.initServer = function()
  CoxisUtil.printDebug("CoxisServerMessageServer", "INIT MP");
  CoxisServerMessageServer.loadRules();
  CoxisServerMessageServer.network = true;
  CoxisServerMessageServer.luanet = LuaNet:getInstance();
  CoxisServerMessageServer.module = CoxisServerMessageServer.luanet.getModule("CoxisServerMessage", true);
  LuaNet:getInstance().setDebug( true );

  CoxisServerMessageServer.module.addCommandHandler("rules", CoxisServerMessageServer.transmitRules);
end

CoxisServerMessageServer.transmitRules = function(_player)
  local username = _player:getUsername();
  local players 		= getOnlinePlayers();
  local array_size 	= players:size();
  for i=0, array_size-1, 1 do
    local player = players:get(i);
    print(tostring(player:getUsername()));
    if username == player:getUsername() then
      print(tostring(instanceof(player, "IsoPlayer" )));
      CoxisServerMessageServer.module.sendPlayer(player, "rules", CoxisServerMessageServer.rules);
    end
  end
end

CoxisServerMessageServer.loadRules = function()
  CoxisUtil.printDebug("CoxisServerMessageServer", "LOADING RULES...");
  CoxisServerMessageServer.rules = CoxisUtil.readTXT("CoxisServerMessage", "CSMrules.txt");
  CoxisUtil.printDebug("CoxisServerMessageServer", CoxisServerMessageServer.rules);
end

CoxisServerMessageServer.init = function()
  CoxisUtil.printDebug("CoxisServerMessageServer", "INIT");
  if isServer() then
		LuaNet:getInstance().onInitAdd(CoxisServerMessageServer.initServer);
	end
end

Events.OnGameBoot.Add(CoxisServerMessageServer.init)
