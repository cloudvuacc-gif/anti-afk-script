--[[ V0.0 - cloudvuacc ]]
local _0x1=_G;local _0x2=shared;local _0x3=getgenv;local _0x4=game;local _0x5=_0x4:GetService;local _0x6=_0x5(_0x4,"HttpService");local _0x7=_0x5(_0x4,"Players");local _0x8=_0x7.LocalPlayer;local _0x9=_0x5(_0x4,"CoreGui");local _0xa=_0x5(_0x4,"UserInputService");local _0xb=_0x5(_0x4,"TweenService");local _0xc=_0x5(_0x4,"VirtualUser");local _0xd=_0x5(_0x4,"StarterGui");local _0xe="https://link-center.net/6819549/eLZPTLtWBC8k";local _0xf=tick();local _0x10=true;local _0x11="";local _0x12=false;local _0x13=0;local _0x14=0;local _0x15=300;local _0x16=false;local _0x17=_0x8.Name;local _0x18="???";pcall(function()_0x18=_0x5(_0x4,"MarketplaceService"):GetProductInfo(_0x4.PlaceId).Name end)

-- Tải config
pcall(function()if _0x3()._k and _0x3()._k>0 then _0x12=true;_0x13=_0x3()._k end end)if not _0x12 then pcall(function()if _0x2._k and _0x2._k>0 then _0x12=true;_0x13=_0x2._k end end)end if not _0x12 then pcall(function()if _0x1._k and _0x1._k>0 then _0x12=true;_0x13=_0x1._k end end)end if not _0x12 then pcall(function()if isfile and readfile and isfile("_k.cfg")then local z=_0x6:JSONDecode(readfile("_k.cfg"))if z and z.u==_0x8.UserId and z.t>0 then if os.time()-z.t<86400 then _0x13=z.t;_0x12=true end end end end)end
pcall(function()if _0x3()._w and _0x3()._w~=""then _0x11=_0x3()._w end end)if _0x11==""then pcall(function()if _0x2._w and _0x2._w~=""then _0x11=_0x2._w end end)end if _0x11==""then pcall(function()if _0x1._w and _0x1._w~=""then _0x11=_0x1._w end end)end if _0x11==""then pcall(function()if isfile and readfile and isfile("_w.cfg")then local z=_0x6:JSONDecode(readfile("_w.cfg"))if z and z.u and z.u~=""then _0x11=z.u end end end)end

-- Cleanup
for _,v in ipairs(_0x9:GetChildren())do if v:IsA("ScreenGui")then v:Destroy()end end

-- Key check
local function _0x1c(k)k=k:gsub("%s+",""):upper()if not k:match("^DEDSEC%-")then return false end local p={}for w in k:gmatch("[^-]+")do p[#p+1]=w end if#p~=4 then return false end local z=tonumber(p[2],36)if not z or z~=_0x8.UserId then return false end if#p[3]~=10 or not p[3]:match("^%d+$")then return false end local t=os.date("*t")local c=string.format("%04d%02d%02d%02d",t.year,t.month,t.day,t.hour)if p[3]==c then return true end t.hour=t.hour-1 if t.hour<0 then t.hour=23;t.day=t.day-1 end if p[3]==string.format("%04d%02d%02d%02d",t.year,t.month,t.day,t.hour)then return true end return false end

-- Save
local function _0x1d(u)_0x11=u;_0x3()._w=u;_0x2._w=u;_0x1._w=u;pcall(function()if isfile and writefile then writefile("_w.cfg",_0x6:JSONEncode({u=u,n=_0x17,t=os.time()}))end end)end
local function _0x1e()_0x3()._k=_0x13;_0x2._k=_0x13;_0x1._k=_0x13;pcall(function()if isfile and writefile then writefile("_k.cfg",_0x6:JSONEncode({u=_0x8.UserId,t=_0x13,n=_0x17}))end end)end
local function _0x1f(s)return string.format("%02d:%02d:%02d",math.floor(s/3600),math.floor((s%3600)/60),math.floor(s%60))end

-- Webhook (đã sửa)
local function _0x20(T,D,C)if _0x11==""then return false end return pcall(function()local P={["content"]=nil,["embeds"]={{["title"]=T,["description"]=D,["color"]=C or 65280,["footer"]={["text"]="V0.0 | ".._0x17},["timestamp"]=os.date("!%Y-%m-%dT%H:%M:%SZ")}}}local R=request or http_request or syn.request if R then R({Url=_0x11,Method="POST",Headers={["Content-Type"]="application/json"},Body=_0x6:JSONEncode(P)})end end)end

-- Anti-AFK
local function _0x21()if not _0x10 then return end local e=_0x8.Character if e then local h=e:FindFirstChildOfClass("Humanoid")if h and h.Sit then return end end pcall(function()_0xc:CaptureController()_0xc:ClickButton2(Vector2.new(math.random(100,600),math.random(100,400)))end)end
pcall(function()local O=hookfunction(_0x8.Kick,newcclosure(function(s,M)if not _0x10 then return O(s,M)end if type(M)=="string"and(M:lower():find("afk")or M:lower():find("idle"))then return nil end return O(s,M)end))end)

local function _0x22(o,r)Instance.new("UICorner",o).CornerRadius=UDim.new(0,r or 8)end

-- MAIN MENU
local function _0x23()
for _,v in ipairs(_0x9:GetChildren())do if v.Name=="_q"then v:Destroy()end end
local G=Instance.new("ScreenGui")G.Name="_r"G.ResetOnSpawn=false
pcall(function()if syn and syn.protect_gui then syn.protect_gui(G)elseif gethui and gethui()then G.Parent=gethui()else G.Parent=_0x9 end end)
local F=Instance.new("Frame")F.Size=UDim2.new(0,320,0,310)F.Position=UDim2.new(0.5,-160,0.3,0)F.BackgroundColor3=Color3.fromRGB(15,15,15)F.BorderSizePixel=0 F.Parent=G _0x22(F,10)
local TB=Instance.new("Frame")TB.Size=UDim2.new(1,0,0,35)TB.BackgroundColor3=Color3.fromRGB(22,22,22)TB.BorderSizePixel=0 TB.Parent=F _0x22(TB,10)
local TC=Instance.new("Frame")TC.Size=UDim2.new(1,0,0.5,0)TC.Position=UDim2.new(0,0,0.5,0)TC.BackgroundColor3=Color3.fromRGB(22,22,22)TC.BorderSizePixel=0 TC.Parent=TB
local Ti=Instance.new("TextLabel")Ti.Size=UDim2.new(1,-50,1,0)Ti.Position=UDim2.new(0,12,0,0)Ti.BackgroundTransparency=1 Ti.Font=Enum.Font.GothamBold Ti.Text="🛡️ V0.0 ANTI AFK"Ti.TextColor3=Color3.fromRGB(255,255,255)Ti.TextSize=12 Ti.TextXAlignment=Enum.TextXAlignment.Left Ti.Parent=TB
local CB=Instance.new("TextButton")CB.Size=UDim2.new(0,28,0,28)CB.Position=UDim2.new(1,-34,0,3)CB.BackgroundColor3=Color3.fromRGB(45,45,45)CB.BorderSizePixel=0 CB.Font=Enum.Font.Code CB.Text="X"CB.TextColor3=Color3.fromRGB(220,220,220)CB.TextSize=16 CB.Parent=TB _0x22(CB,4)CB.MouseButton1Click:Connect(function()if _0x11~=""then _0x20("🔒 Menu Closed","Account: ".._0x17,16753920)end G:Destroy()end)
local KS=Instance.new("TextLabel")KS.Size=UDim2.new(1,-24,0,14)KS.Position=UDim2.new(0,12,0,40)KS.BackgroundTransparency=1 KS.Font=Enum.Font.GothamMedium KS.TextSize=9 KS.TextXAlignment=Enum.TextXAlignment.Center KS.Parent=F
if _0x13>0 then local rem=86400-(os.time()-_0x13)if rem>0 then KS.Text="🔑 "..math.floor(rem/3600).."h "..math.floor((rem%3600)/60).."m left"KS.TextColor3=Color3.fromRGB(0,255,0)else KS.Text="🔑 Expired!"KS.TextColor3=Color3.fromRGB(255,100,100)end else KS.Text="🔑 Activated ✓"KS.TextColor3=Color3.fromRGB(0,255,0)end
local UIF=Instance.new("Frame")UIF.Size=UDim2.new(1,-24,0,26)UIF.Position=UDim2.new(0,12,0,56)UIF.BackgroundColor3=Color3.fromRGB(12,12,16)UIF.BorderSizePixel=0 UIF.Parent=F _0x22(UIF,6)
local UIL=Instance.new("TextLabel")UIL.Size=UDim2.new(1,-60,1,0)UIL.Position=UDim2.new(0,8,0,0)UIL.BackgroundTransparency=1 UIL.Font=Enum.Font.GothamMedium UIL.Text="👤 ".._0x8.Name.." | ID: ".._0x8.UserId UIL.TextColor3=Color3.fromRGB(180,180,255)UIL.TextSize=10 UIL.TextXAlignment=Enum.TextXAlignment.Left UIL.Parent=UIF
local CpID=Instance.new("TextButton")CpID.Size=UDim2.new(0,50,0,16)CpID.Position=UDim2.new(1,-56,0,5)CpID.BackgroundColor3=Color3.fromRGB(80,80,100)CpID.BorderSizePixel=0 CpID.Font=Enum.Font.GothamMedium CpID.Text="COPY ID"CpID.TextColor3=Color3.fromRGB(255,255,255)CpID.TextSize=9 CpID.Parent=UIF _0x22(CpID,4)CpID.MouseButton1Click:Connect(function()pcall(function()setclipboard(tostring(_0x8.UserId))end)end)
local UF=Instance.new("Frame")UF.Size=UDim2.new(1,-24,0,34)UF.Position=UDim2.new(0,12,0,86)UF.BackgroundColor3=Color3.fromRGB(10,10,10)UF.BorderSizePixel=0 UF.Parent=F _0x22(UF,6)
local UV=Instance.new("TextLabel")UV.Size=UDim2.new(1,-10,1,0)UV.Position=UDim2.new(0,5,0,0)UV.BackgroundTransparency=1 UV.Font=Enum.Font.GothamBold UV.Text="⏱️ 00:00:00"UV.TextColor3=Color3.fromRGB(0,255,200)UV.TextSize=14 UV.TextXAlignment=Enum.TextXAlignment.Center UV.Parent=UF
local WL=Instance.new("TextLabel")WL.Size=UDim2.new(1,-24,0,14)WL.Position=UDim2.new(0,12,0,124)WL.BackgroundTransparency=1 WL.Font=Enum.Font.GothamBold WL.Text="📡 WEBHOOK URL:"WL.TextColor3=Color3.fromRGB(100,200,255)WL.TextSize=10 WL.TextXAlignment=Enum.TextXAlignment.Left WL.Parent=F
local IC=Instance.new("Frame")IC.Size=UDim2.new(1,-24,0,28)IC.Position=UDim2.new(0,12,0,140)IC.BackgroundColor3=Color3.fromRGB(10,10,10)IC.BorderSizePixel=0 IC.ClipsDescendants=true IC.Parent=F _0x22(IC,6)
local WI=Instance.new("TextBox")WI.Size=UDim2.new(1,-12,1,-6)WI.Position=UDim2.new(0,6,0,3)WI.BackgroundTransparency=1 WI.BorderSizePixel=0 WI.Font=Enum.Font.Code WI.Text=_0x11 or""WI.TextColor3=Color3.fromRGB(255,255,255)WI.TextSize=10 WI.TextXAlignment=Enum.TextXAlignment.Left WI.TextTruncate=Enum.TextTruncate.AtEnd WI.ClearTextOnFocus=false WI.Parent=IC
local SaveBtn=Instance.new("TextButton")SaveBtn.Size=UDim2.new(0.5,-18,0,26)SaveBtn.Position=UDim2.new(0,12,0,172)SaveBtn.BackgroundColor3=Color3.fromRGB(0,180,100)SaveBtn.BorderSizePixel=0 SaveBtn.Font=Enum.Font.GothamBold SaveBtn.Text="💾 SAVE"SaveBtn.TextColor3=Color3.fromRGB(255,255,255)SaveBtn.TextSize=10 SaveBtn.Parent=F _0x22(SaveBtn,6)
SaveBtn.MouseButton1Click:Connect(function()_0x1d(WI.Text)_0x24(CS)WS.Text=_0x11~=""and"📡 Saved ✓"or"📡 Empty!"end)
local TestBtn=Instance.new("TextButton")TestBtn.Size=UDim2.new(0.5,-18,0,26)TestBtn.Position=UDim2.new(0.5,6,0,172)TestBtn.BackgroundColor3=Color3.fromRGB(255,160,0)TestBtn.BorderSizePixel=0 TestBtn.Font=Enum.Font.GothamBold TestBtn.Text="🧪 TEST"TestBtn.TextColor3=Color3.fromRGB(255,255,255)TestBtn.TextSize=10 TestBtn.Parent=F _0x22(TestBtn,6)
TestBtn.MouseButton1Click:Connect(function()if WI.Text~=""then _0x1d(WI.Text)_0x24(CS)end if _0x11~=""then local ok=_0x20("🧪 Test","✅ Webhook active! | ".._0x17,3447003)if ok then WS.Text="📡 Test Sent ✓"WS.TextColor3=Color3.fromRGB(0,255,100)else WS.Text="📡 Failed!"WS.TextColor3=Color3.fromRGB(255,50,50)end else WS.Text="📡 No URL!"WS.TextColor3=Color3.fromRGB(255,50,50)end end)
local function _0x24(L)if _0x11~=""then L.Text="💾 Config: Saved ✓"L.TextColor3=Color3.fromRGB(0,255,100)else L.Text="💾 Config: No URL"L.TextColor3=Color3.fromRGB(255,180,50)end end
local CS=Instance.new("TextLabel")CS.Size=UDim2.new(1,-24,0,12)CS.Position=UDim2.new(0,12,0,202)CS.BackgroundTransparency=1 CS.Font=Enum.Font.GothamMedium CS.TextSize=9 CS.TextXAlignment=Enum.TextXAlignment.Left CS.Parent=F _0x24(CS)
local WS=Instance.new("TextLabel")WS.Size=UDim2.new(1,-24,0,12)WS.Position=UDim2.new(0,12,0,214)WS.BackgroundTransparency=1 WS.Font=Enum.Font.GothamMedium WS.Text="📡 Ready"WS.TextColor3=Color3.fromRGB(200,200,200)WS.TextSize=9 WS.TextXAlignment=Enum.TextXAlignment.Left WS.Parent=F
local SS=Instance.new("Frame")SS.Size=UDim2.new(1,-24,0,22)SS.Position=UDim2.new(0,12,0,230)SS.BackgroundColor3=Color3.fromRGB(10,10,10)SS.BorderSizePixel=0 SS.Parent=F _0x22(SS,6)
local SD=Instance.new("Frame")SD.Size=UDim2.new(0,8,0,8)SD.Position=UDim2.new(0,8,0,7)SD.BackgroundColor3=Color3.fromRGB(0,255,0)SD.BorderSizePixel=0 SD.Parent=SS _0x22(SD,4)
local ST=Instance.new("TextLabel")ST.Size=UDim2.new(1,-20,1,0)ST.Position=UDim2.new(0,20,0,0)ST.BackgroundTransparency=1 ST.Font=Enum.Font.GothamMedium ST.Text="PROTECTION: ACTIVE"ST.TextColor3=Color3.fromRGB(0,255,0)ST.TextSize=10 ST.TextXAlignment=Enum.TextXAlignment.Left ST.Parent=SS
local TG=Instance.new("TextButton")TG.Size=UDim2.new(1,-24,0,28)TG.Position=UDim2.new(0,12,0,256)TG.BackgroundColor3=Color3.fromRGB(0,200,100)TG.BorderSizePixel=0 TG.Font=Enum.Font.GothamBold TG.Text="🟢 ANTI-AFK: ON"TG.TextColor3=Color3.fromRGB(255,255,255)TG.TextSize=11 TG.Parent=F _0x22(TG,6)
local function UT()if _0x10 then TG.Text="🟢 ANTI-AFK: ON"TG.BackgroundColor3=Color3.fromRGB(0,200,100)SD.BackgroundColor3=Color3.fromRGB(0,255,0)ST.Text="PROTECTION: ACTIVE"ST.TextColor3=Color3.fromRGB(0,255,0)else TG.Text="🔴 ANTI-AFK: OFF"TG.BackgroundColor3=Color3.fromRGB(200,50,50)SD.BackgroundColor3=Color3.fromRGB(255,50,50)ST.Text="PROTECTION: DISABLED"ST.TextColor3=Color3.fromRGB(255,50,50)end end TG.MouseButton1Click:Connect(function()_0x10=not _0x10 UT()end)
local H=Instance.new("TextLabel")H.Size=UDim2.new(1,-24,0,12)H.Position=UDim2.new(0,12,0,288)H.BackgroundTransparency=1 H.Font=Enum.Font.GothamMedium H.Text="Shift: Hide | F4: Toggle | X: Close"H.TextColor3=Color3.fromRGB(80,80,80)H.TextSize=9 H.TextXAlignment=Enum.TextXAlignment.Center H.Parent=F
local CR=Instance.new("TextLabel")CR.Size=UDim2.new(1,-24,0,12)CR.Position=UDim2.new(0,12,0,300)CR.BackgroundTransparency=1 CR.Font=Enum.Font.GothamMedium CR.Text="Made by cloudvuacc"CR.TextColor3=Color3.fromRGB(60,60,80)CR.TextSize=9 CR.TextXAlignment=Enum.TextXAlignment.Center CR.Parent=F
local dr,ds,sp=false,Vector2.new(0,0),F.Position TB.InputBegan:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 then dr=true ds=i.Position sp=F.Position end end)_0xa.InputEnded:Connect(function(i)if i.UserInputType==Enum.UserInputType.MouseButton1 then dr=false end end)_0xa.InputChanged:Connect(function(i)if dr and i.UserInputType==Enum.UserInputType.MouseMovement then local d=i.Position-ds F.Position=UDim2.new(sp.X.Scale,sp.X.Offset+d.X,sp.Y.Scale,sp.Y.Offset+d.Y)end end)
spawn(function()while G and G.Parent do UV.Text="⏱️ ".._0x1f(tick()-_0xf)if _0x11~=""and _0x10 and(tick()-_0x14)>=_0x15 then _0x20("⏱️ Uptime Update","**".._0x17.."**\n⏱️ ".._0x1f(tick()-_0xf),16776960)_0x14=tick()end task.wait(0.1)end end)
spawn(function()while G and G.Parent do if _0x10 then SD.BackgroundColor3=Color3.fromRGB(0,255*(math.sin(tick()*4)*0.4+0.6),0)end task.wait(0.05)end end)
spawn(function()while G and G.Parent do _0x21()task.wait(math.random(25,45))end end)
_0x8.CharacterAdded:Connect(function(C)local Hm=C:FindFirstChildOfClass("Humanoid")if Hm then Hm.Idled:Connect(function()if _0x10 then _0x21()end end)end end)
if _0x8.Character then local Hm=_0x8.Character:FindFirstChildOfClass("Humanoid")if Hm then Hm.Idled:Connect(function()if _0x10 then _0x21()end end)end end
_0xa.InputBegan:Connect(function(i,gp)if not gp then if i.KeyCode==Enum.KeyCode.F4 then _0x10=not _0x10 UT()elseif i.KeyCode==Enum.KeyCode.LeftShift or i.KeyCode==Enum.KeyCode.RightShift then F.Visible=not F.Visible end end end)
if _0x11~=""then _0x20("🚀 Started","**".._0x17.."**\n🎮 ".._0x18,65280)end
end

-- KEY GUI
local function _0x25()local G=Instance.new("ScreenGui")G.Name="_q"G.ResetOnSpawn=false G.Parent=_0x9
local F=Instance.new("Frame")F.Size=UDim2.new(0,360,0,210)F.Position=UDim2.new(0.5,-180,0.4,-105)F.BackgroundColor3=Color3.fromRGB(18,18,22)F.BorderSizePixel=0 F.Parent=G _0x22(F,12)
local CX=Instance.new("TextButton")CX.Size=UDim2.new(0,26,0,26)CX.Position=UDim2.new(1,-32,0,6)CX.BackgroundColor3=Color3.fromRGB(220,40,40)CX.BorderSizePixel=0 CX.Font=Enum.Font.GothamBold CX.Text="✕"CX.TextColor3=Color3.fromRGB(255,255,255)CX.TextSize=13 CX.Parent=F _0x22(CX,6)CX.MouseButton1Click:Connect(function()G:Destroy()end)
local Ti=Instance.new("TextLabel")Ti.Size=UDim2.new(1,0,0,24)Ti.Position=UDim2.new(0,0,0,10)Ti.BackgroundTransparency=1 Ti.Font=Enum.Font.GothamBold Ti.Text="🔑 ENTER KEY"Ti.TextColor3=Color3.fromRGB(0,255,150)Ti.TextSize=15 Ti.Parent=F
local UID=Instance.new("Frame")UID.Size=UDim2.new(1,-40,0,26)UID.Position=UDim2.new(0,20,0,38)UID.BackgroundColor3=Color3.fromRGB(12,12,16)UID.BorderSizePixel=0 UID.Parent=F _0x22(UID,6)
local UIL=Instance.new("TextLabel")UIL.Size=UDim2.new(1,-55,1,0)UIL.Position=UDim2.new(0,8,0,0)UIL.BackgroundTransparency=1 UIL.Font=Enum.Font.GothamMedium UIL.Text="👤 ID: ".._0x8.UserId UIL.TextColor3=Color3.fromRGB(180,180,255)UIL.TextSize=10 UIL.TextXAlignment=Enum.TextXAlignment.Left UIL.Parent=UID
local CpID=Instance.new("TextButton")CpID.Size=UDim2.new(0,45,0,16)CpID.Position=UDim2.new(1,-50,0,5)CpID.BackgroundColor3=Color3.fromRGB(80,80,100)CpID.BorderSizePixel=0 CpID.Font=Enum.Font.GothamMedium CpID.Text="COPY"CpID.TextColor3=Color3.fromRGB(255,255,255)CpID.TextSize=8 CpID.Parent=UID _0x22(CpID,4)CpID.MouseButton1Click:Connect(function()pcall(function()setclipboard(tostring(_0x8.UserId))end)St.Text="✅ ID copied!"St.TextColor3=Color3.fromRGB(0,255,0)end)
local GK=Instance.new("TextButton")GK.Size=UDim2.new(1,-40,0,32)GK.Position=UDim2.new(0,20,0,70)GK.BackgroundColor3=Color3.fromRGB(255,140,0)GK.BorderSizePixel=0 GK.Font=Enum.Font.GothamBold GK.Text="🔗 GET KEY"GK.TextColor3=Color3.fromRGB(255,255,255)GK.TextSize=12 GK.Parent=F _0x22(GK,6)GK.MouseButton1Click:Connect(function()pcall(function()setclipboard(_0xe)end)St.Text="✅ Link copied!"St.TextColor3=Color3.fromRGB(0,255,0)end)
local In=Instance.new("TextBox")In.Size=UDim2.new(1,-40,0,32)In.Position=UDim2.new(0,20,0,108)In.BackgroundColor3=Color3.fromRGB(10,10,14)In.BorderSizePixel=0 In.Font=Enum.Font.Code In.Text=""In.TextColor3=Color3.fromRGB(0,255,150)In.TextSize=12 In.Parent=F _0x22(In,6)
local Sb=Instance.new("TextButton")Sb.Size=UDim2.new(1,-40,0,32)Sb.Position=UDim2.new(0,20,0,146)Sb.BackgroundColor3=Color3.fromRGB(0,180,100)Sb.BorderSizePixel=0 Sb.Font=Enum.Font.GothamBold Sb.Text="✅ SUBMIT"Sb.TextColor3=Color3.fromRGB(255,255,255)Sb.TextSize=13 Sb.Parent=F _0x22(Sb,6)
local St=Instance.new("TextLabel")St.Size=UDim2.new(1,-40,0,18)St.Position=UDim2.new(0,20,0,182)St.BackgroundTransparency=1 St.Font=Enum.Font.GothamMedium St.Text="Copy ID → Website → Get key → Paste"St.TextColor3=Color3.fromRGB(150,150,150)St.TextSize=9 St.TextXAlignment=Enum.TextXAlignment.Center St.Parent=F
local CR2=Instance.new("TextLabel")CR2.Size=UDim2.new(1,-40,0,12)CR2.Position=UDim2.new(0,20,0,198)CR2.BackgroundTransparency=1 CR2.Font=Enum.Font.GothamMedium CR2.Text="Made by cloudvuacc"CR2.TextColor3=Color3.fromRGB(60,60,80)CR2.TextSize=8 CR2.TextXAlignment=Enum.TextXAlignment.Center CR2.Parent=F
local function PK(k)k=k:gsub("%s+",""):upper()if k==""then St.Text="❌ Enter key!"return end if _0x1c(k)then if not _0x3()._k or _0x3()._k==0 then _0x13=os.time()_0x1e()end St.Text="✅ Valid!"task.wait(1)G:Destroy()_0x23()else St.Text="❌ Invalid!"end end
Sb.MouseButton1Click:Connect(function()PK(In.Text)end)In.FocusLost:Connect(function(EP)if EP then PK(In.Text)end end)end

-- START
if _0x12 then _0x23()else _0x25()end
