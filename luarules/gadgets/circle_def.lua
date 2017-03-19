function gadget:GetInfo()
  return {
    name      = "circle def",
    desc      = "circle def",
    author    = "-",
    date      = "",
    license   = "GNU GPL, v2 or later",
    layer     = 0,
    enabled   = true  --  loaded by default?
  }
end

--------------------------------------------------------------------------------
--------------------------------------------------------------------------------

if (not gadgetHandler:IsSyncedCode()) then
  return
end

local globallos = tonumber(Spring.GetModOptions().mo_globallos) or 1
Spring.SetGlobalLos(1, true)
Spring.SetGlobalLos(2, true)

if (globallos == 1) then
  Spring.Echo('globallos 1')
  Spring.SetGlobalLos(1, true)
else
  Spring.Echo('globallos 0')

end
