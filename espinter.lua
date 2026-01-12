local run = game:GetService("RunService")
local plrs = game:GetService("Players")
local ws = game:GetService("Workspace")

local lp = plrs.LocalPlayer
local cam = ws.CurrentCamera
local vs = cam.ViewportSize
local gui = Instance.new("Folder", gethui and gethui() or game:GetService("CoreGui"))

local fl = math.floor
local rd = math.round
local sn = math.sin
local cs = math.cos
local cl = table.clear
local up = table.unpack
local fd = table.find
local cr = table.create
local fm = CFrame.fromMatrix

local w2s = cam.WorldToViewportPoint
local isA = ws.IsA
local gp = ws.GetPivot
local fc = ws.FindFirstChild
local fcc = ws.FindFirstChildOfClass
local gc = ws.GetChildren
local to = CFrame.identity.ToOrientation
local pos = CFrame.identity.PointToObjectSpace
local lc = Color3.new().Lerp
local m2 = Vector2.zero.Min
local m2x = Vector2.zero.Max
local l2 = Vector2.zero.Lerp
local m3 = Vector3.zero.Min
local m3x = Vector3.zero.Max

local HB_OFF = Vector2.new(5, 0)
local HT_OFF = Vector2.new(3, 0)
local HO_OFF = Vector2.new(0, 1)
local N_OFF = Vector2.new(0, 2)
local D_OFF = Vector2.new(0, 2)
local AB_OFF = Vector2.new(5, 0)
local AT_OFF = Vector2.new(30, 0)
local AO_OFF = Vector2.new(0, 1)
local VERTS = {
	Vector3.new(-1, -1, -1),
	Vector3.new(-1, 1, -1),
	Vector3.new(-1, 1, 1),
	Vector3.new(-1, -1, 1),
	Vector3.new(1, -1, -1),
	Vector3.new(1, 1, -1),
	Vector3.new(1, 1, 1),
	Vector3.new(1, -1, 1)
}

local function isBP(n)
	return n == "Head" or n:find("Torso") or n:find("Leg") or n:find("Arm")
end

local function getBB(parts)
	local mn, mx
	for i = 1, #parts do
		local p = parts[i]
		local cf, sz = p.CFrame, p.Size
		mn = m3(mn or cf.Position, (cf - sz*0.5).Position)
		mx = m3x(mx or cf.Position, (cf + sz*0.5).Position)
	end
	local c = (mn + mx)*0.5
	local f = Vector3.new(c.X, c.Y, mx.Z)
	return CFrame.new(c, f), mx - mn
end

local function w2sc(w)
	local s, inB = w2s(cam, w)
	return Vector2.new(s.X, s.Y), inB, s.Z
end

local function calcCorn(cf, sz)
	local corn = cr(#VERTS)
	for i = 1, #VERTS do
		corn[i] = w2sc((cf + sz*0.5*VERTS[i]).Position)
	end
	local mn = m2(vs, up(corn))
	local mx = m2x(Vector2.zero, up(corn))
	return {
		corners = corn,
		tl = Vector2.new(fl(mn.X), fl(mn.Y)),
		tr = Vector2.new(fl(mx.X), fl(mn.Y)),
		bl = Vector2.new(fl(mn.X), fl(mx.Y)),
		br = Vector2.new(fl(mx.X), fl(mx.Y))
	}
end

local function rotV(v, rad)
	local x, y = v.X, v.Y
	local c, s = cs(rad), sn(rad)
	return Vector2.new(x*c - y*s, x*s + y*c)
end

local function parseC(self, col, out)
	if col == "Team Color" or (self.itf.shSet.useTeam and not out) then
		return self.itf.getTC(self.plr) or Color3.new(1,1,1)
	end
	return col
end

local Esp = {}
Esp.__index = Esp

function Esp.new(p, itf)
	local self = setmetatable({}, Esp)
	self.plr = assert(p, "No player")
	self.itf = assert(itf, "No interface")
	self:init()
	return self
end

function Esp:_c(cls, props)
	local d = Drawing.new(cls)
	for prop, val in next, props do
		pcall(function() d[prop] = val end)
	end
	self.bin[#self.bin + 1] = d
	return d
end

function Esp:init()
	self.charCache = {}
	self.childCnt = 0
	self.bin = {}
	self.draw = {
		skel = {
			hd = self:_c("Line", { Thickness = 2, Visible = false }),
			nt = self:_c("Line", { Thickness = 2, Visible = false }),
			ls = self:_c("Line", { Thickness = 2, Visible = false }),
			rs = self:_c("Line", { Thickness = 2, Visible = false }),
			la = self:_c("Line", { Thickness = 2, Visible = false }),
			ra = self:_c("Line", { Thickness = 2, Visible = false }),
			ll = self:_c("Line", { Thickness = 2, Visible = false }),
			rl = self:_c("Line", { Thickness = 2, Visible = false }),
			bh = self:_c("Line", { Thickness = 2, Visible = false }),
			rlb = self:_c("Line", { Thickness = 2, Visible = false })
		},
		gskel = {
			hd = self:_c("Line", { Thickness = 3, Visible = false }),
			nt = self:_c("Line", { Thickness = 3, Visible = false }),
			ls = self:_c("Line", { Thickness = 3, Visible = false }),
			rs = self:_c("Line", { Thickness = 3, Visible = false }),
			la = self:_c("Line", { Thickness = 3, Visible = false }),
			ra = self:_c("Line", { Thickness = 3, Visible = false }),
			ll = self:_c("Line", { Thickness = 3, Visible = false }),
			rl = self:_c("Line", { Thickness = 3, Visible = false }),
			bh = self:_c("Line", { Thickness = 3, Visible = false }),
			rlb = self:_c("Line", { Thickness = 3, Visible = false })
		},
		b3d = {
			{ self:_c("Line", { Thickness = 1, Visible = false }),
			  self:_c("Line", { Thickness = 1, Visible = false }),
			  self:_c("Line", { Thickness = 1, Visible = false }) },
			{ self:_c("Line", { Thickness = 1, Visible = false }),
			  self:_c("Line", { Thickness = 1, Visible = false }),
			  self:_c("Line", { Thickness = 1, Visible = false }) },
			{ self:_c("Line", { Thickness = 1, Visible = false }),
			  self:_c("Line", { Thickness = 1, Visible = false }),
			  self:_c("Line", { Thickness = 1, Visible = false }) },
			{ self:_c("Line", { Thickness = 1, Visible = false }),
			  self:_c("Line", { Thickness = 1, Visible = false }),
			  self:_c("Line", { Thickness = 1, Visible = false }) }
		},
		v = {
			tro = self:_c("Line", { Thickness = 3, Visible = false }),
			tr = self:_c("Line", { Thickness = 1, Visible = false }),
			bf = self:_c("Square", { Filled = true, Visible = false }),
			bo = self:_c("Square", { Thickness = 3, Visible = false }),
			b = self:_c("Square", { Thickness = 1, Visible = false }),
			hbo = self:_c("Line", { Thickness = 3, Visible = false }),
			hb = self:_c("Line", { Thickness = 1, Visible = false }),
			ht = self:_c("Text", { Center = true, Visible = false }),
			n = self:_c("Text", { Text = self.plr.DisplayName, Center = true, Visible = false }),
			d = self:_c("Text", { Center = true, Visible = false }),
			w = self:_c("Text", { Center = true, Visible = false }),
			
			abo = self:_c("Line", { Thickness = 3, Visible = false }),
			ab = self:_c("Line", { Thickness = 1, Visible = false }),
			at = self:_c("Text", { Center = true, Visible = false }),
		},
		h = {
			aro = self:_c("Triangle", { Thickness = 3, Visible = false }),
			ar = self:_c("Triangle", { Filled = true, Visible = false })
		}
	}

	self.rendCon = run.Heartbeat:Connect(function(dt)
		self:Upd(dt)
		self:Ren(dt)
	end)
end

function Esp:Dest()
	self.rendCon:Disconnect()
	for i = 1, #self.bin do
		self.bin[i]:Remove()
	end
	cl(self)
end
function Esp:Upd()
    local itf = self.itf
    self.opt = itf.tSet[itf.isFr(self.plr) and "fr" or "en"]
    if not self.plr or not self.plr.Parent then
        self.en = false
        self.char = nil
        self.onSc = false
        return
    end
    
    self.char = itf.getChar(self.plr)
    self.hp, self.maxHp = itf.getHp(self.plr)
    self.arm = itf.getArm(self.plr)
    self.wep = itf.getWep(self.plr)
    local hasUserId = pcall(function() 
        return self.plr.UserId ~= nil
    end)
    if self.plr == lp and not self.itf.allowlocal then
        self.en = false
    else
        self.en = self.opt.en and self.char and hasUserId and not
            (#itf.wlist > 0 and not fd(itf.wlist, self.plr.UserId))
    end

    local hd = self.en and fc(self.char, "Head")
    if not hd then
        self.charCache = {}
        self.onSc = false
        return
    end

    local _, onSc, dep = w2sc(hd.Position)
    self.onSc = onSc
    self.dis = dep

    if itf.shSet.limDis and dep > itf.shSet.maxDis then
        self.onSc = false
    end

    if self.onSc then
		self:updateSkel()
        local ch = self.charCache
        local kids = gc(self.char)
        if not ch[1] or self.childCnt ~= #kids then
            cl(ch)
            for i = 1, #kids do
                local p = kids[i]
                if isA(p, "BasePart") and isBP(p.Name) then
                    ch[#ch + 1] = p
                end
            end
            self.childCnt = #kids
        end
        self.corn = calcCorn(getBB(ch))
    elseif self.opt.offAr then
        local cf = cam.CFrame
        local flt = fm(cf.Position, cf.RightVector, Vector3.yAxis)
        local obj = pos(flt, hd.Position)
        self.dir = Vector2.new(obj.X, obj.Z).Unit
    end
end
function Esp:Ren()
	local onSc = self.onSc or false
	local en = self.en or false
	local v = self.draw.v
	local h = self.draw.h
	local b3d = self.draw.b3d
	local itf = self.itf
	local opt = self.opt
	local corn = self.corn

	v.b.Visible = en and onSc and opt.box
	v.bo.Visible = v.b.Visible and opt.boxO
	if v.b.Visible then
		local b = v.b
		b.Position = corn.tl
		b.Size = corn.br - corn.tl
		b.Color = parseC(self, opt.boxCol[1])
		b.Transparency = opt.boxCol[2]

		local bo = v.bo
		bo.Position = b.Position
		bo.Size = b.Size
		bo.Color = parseC(self, opt.boxOCol[1], true)
		bo.Transparency = opt.boxOCol[2]
	end

	v.bf.Visible = en and onSc and opt.boxF
	if v.bf.Visible then
		local bf = v.bf
		bf.Position = corn.tl
		bf.Size = corn.br - corn.tl
		bf.Color = parseC(self, opt.boxFCol[1])
		bf.Transparency = opt.boxFCol[2]
	end

	v.hb.Visible = en and onSc and opt.hb
	v.hbo.Visible = v.hb.Visible and opt.hbo
	if v.hb.Visible then
		local fr = corn.tl - HB_OFF
		local to = corn.bl - HB_OFF

		local hb = v.hb
		hb.To = to
		hb.From = l2(to, fr, self.hp/self.maxHp)
		hb.Color = lc(opt.dyCol, opt.hlCol, self.hp/self.maxHp)

		local hbo = v.hbo
		hbo.To = to + HO_OFF
		hbo.From = fr - HO_OFF
		hbo.Color = parseC(self, opt.hboCol[1], true)
		hbo.Transparency = opt.hboCol[2]
	end

	v.ht.Visible = en and onSc and opt.ht
	if v.ht.Visible then
		local fr = corn.tl - HB_OFF
		local to = corn.bl - HB_OFF

		local ht = v.ht
		ht.Text = rd(self.hp) .. "hp"
		ht.Size = itf.shSet.tSz
		ht.Font = itf.shSet.tFnt
		ht.Color = parseC(self, opt.htCol[1])
		ht.Transparency = opt.htCol[2]
		ht.Outline = opt.htOut
		ht.OutlineColor = parseC(self, opt.htOCol, true)
		ht.Position = l2(to, fr, self.hp/self.maxHp) - ht.TextBounds*0.5 - HT_OFF
	end

	v.ab.Visible = en and onSc and opt.ab
	v.abo.Visible = v.ab.Visible and opt.abo
	if v.ab.Visible then
		local fr = corn.tr + AB_OFF
		local to = corn.br + AB_OFF
		local maxArm = 200
		local bh = (to.Y - fr.Y) * 0.8
		local co = (to.Y - fr.Y) * 0.1 
		to = Vector2.new(to.X, fr.Y + bh) - Vector2.new(0, co)
		fr = fr + Vector2.new(0, co)
		
		local ab = v.ab
		ab.To = to
		ab.From = l2(to, fr, self.arm/maxArm)
		ab.Color = opt.abCol[1]
		
		local abo = v.abo
		abo.To = to + AO_OFF
		abo.From = fr - AO_OFF
		abo.Color = parseC(self, opt.aboCol[1], true)
		abo.Transparency = opt.aboCol[2]
	end

	v.at.Visible = en and onSc and opt.at
	if v.at.Visible then
		local fr = corn.tr + AB_OFF
		local to = corn.br + AB_OFF
		local maxArm = 200

		local at = v.at
		at.Text = rd(self.arm) .. "ap"
		at.Size = itf.shSet.tSz
		at.Font = itf.shSet.tFnt
		at.Color = parseC(self, opt.atCol[1])
		at.Transparency = opt.atCol[2]
		at.Outline = opt.atOut
		at.OutlineColor = parseC(self, opt.atOCol, true)
		at.Position = l2(to, fr, self.arm/maxArm) - at.TextBounds*0.5 + AT_OFF
	end

	v.n.Visible = en and onSc and opt.name
	if v.n.Visible then
		local n = v.n
		n.Size = itf.shSet.tSz
		n.Font = itf.shSet.tFnt
		n.Color = parseC(self, opt.nCol[1])
		n.Transparency = opt.nCol[2]
		n.Outline = opt.nOut
		n.OutlineColor = parseC(self, opt.nOCol, true)
		n.Position = (corn.tl + corn.tr)*0.5 - Vector2.yAxis*n.TextBounds.Y - N_OFF
	end

	v.d.Visible = en and onSc and self.dis and opt.dis
	if v.d.Visible then
		local d = v.d
		d.Text = rd(self.dis) .. " studs"
		d.Size = itf.shSet.tSz
		d.Font = itf.shSet.tFnt
		d.Color = parseC(self, opt.dCol[1])
		d.Transparency = opt.dCol[2]
		d.Outline = opt.dOut
		d.OutlineColor = parseC(self, opt.dOCol, true)
		d.Position = (corn.bl + corn.br)*0.5 + D_OFF
	end

	v.w.Visible = en and onSc and opt.wep
	if v.w.Visible then
		local w = v.w
		w.Text = self.wep
		w.Size = itf.shSet.tSz
		w.Font = itf.shSet.tFnt
		w.Color = parseC(self, opt.wCol[1])
		w.Transparency = opt.wCol[2]
		w.Outline = opt.wOut
		w.OutlineColor = parseC(self, opt.wOCol, true)
		w.Position = (corn.bl + corn.br)*0.5 + (v.d.Visible and D_OFF + Vector2.yAxis*v.d.TextBounds.Y or Vector2.zero)
	end

	v.tr.Visible = en and onSc and opt.tr
	v.tro.Visible = v.tr.Visible and opt.tro
	if v.tr.Visible then
		local tr = v.tr
		tr.Color = parseC(self, opt.trCol[1])
		tr.Transparency = opt.trCol[2]
		tr.To = (corn.bl + corn.br)*0.5
		tr.From =
			opt.trOrg == "Middle" and vs*0.5 or
			opt.trOrg == "Top" and vs*Vector2.new(0.5, 0) or
			opt.trOrg == "Bottom" and vs*Vector2.new(0.5, 1)

		local tro = v.tro
		tro.Color = parseC(self, opt.troCol[1], true)
		tro.Transparency = opt.troCol[2]
		tro.To = tr.To
		tro.From = tr.From
	end

	h.ar.Visible = en and (not onSc) and opt.offAr
	h.aro.Visible = h.ar.Visible and opt.offArO
	if h.ar.Visible and self.dir then
		local ar = h.ar
		ar.PointA = m2(m2x(vs*0.5 + self.dir*opt.offArRad, Vector2.one*25), vs - Vector2.one*25)
		ar.PointB = ar.PointA - rotV(self.dir, 0.45)*opt.offArSz
		ar.PointC = ar.PointA - rotV(self.dir, -0.45)*opt.offArSz
		ar.Color = parseC(self, opt.offArCol[1])
		ar.Transparency = opt.offArCol[2]

		local aro = h.aro
		aro.PointA = ar.PointA
		aro.PointB = ar.PointB
		aro.PointC = ar.PointC
		aro.Color = parseC(self, opt.offArOCol[1], true)
		aro.Transparency = opt.offArOCol[2]
	end

	local b3dEn = en and onSc and opt.b3d
	for i = 1, #b3d do
		local f = b3d[i]
		for i2 = 1, #f do
			local ln = f[i2]
			ln.Visible = b3dEn
			ln.Color = parseC(self, opt.b3dCol[1])
			ln.Transparency = opt.b3dCol[2]
		end

		if b3dEn then
			local l1 = f[1]
			l1.From = corn.corners[i]
			l1.To = corn.corners[i == 4 and 1 or i+1]

			local l2 = f[2]
			l2.From = corn.corners[i == 4 and 1 or i+1]
			l2.To = corn.corners[i == 4 and 5 or i+5]

			local l3 = f[3]
			l3.From = corn.corners[i == 4 and 5 or i+5]
			l3.To = corn.corners[i == 4 and 8 or i+4]
		end
	end
	local skelEn = en and onSc and opt.skel
	local skel = self.draw.skel
	local gskel = self.draw.gskel

	if skelEn and self.skpts then
		local pts = self.skpts
		
		local function drwln(ln, p1, p2)
			if p1 and p2 then
				local s1, v1 = w2sc(p1)
				local s2, v2 = w2sc(p2)
				if v1 and v2 then
					ln.From = s1
					ln.To = s2
					ln.Visible = true
					ln.Color = parseC(self, opt.skelCol[1])
					ln.Transparency = opt.skelCol[2]
					return true
				end
			end
			ln.Visible = false
			return false
		end
		drwln(skel.hd, pts.hd, pts.ur)
		drwln(skel.nt, pts.ur, pts.lr)
		drwln(skel.ls, pts.ur, pts.lua)
		drwln(skel.rs, pts.ur, pts.rua)
		drwln(skel.la, pts.lua, pts.lfa)
		drwln(skel.ra, pts.rua, pts.rfa)
		drwln(skel.ll, pts.lr, pts.lul)
		drwln(skel.rl, pts.lr, pts.rul)
		drwln(skel.bh, pts.lul, pts.lll)
		if not self.draw.skel.rlb then
			self.draw.skel.rlb = self:_c("Line", { Thickness = 2, Visible = false })
			self.draw.gskel.rlb = self:_c("Line", { Thickness = 3, Visible = false })
			table.insert(self.bin, self.draw.skel.rlb)
			table.insert(self.bin, self.draw.gskel.rlb)
		end
		
		drwln(skel.rlb, pts.rul, pts.rll)
		
		if opt.gskel then
			drwln(gskel.hd, pts.hd, pts.ur)
			drwln(gskel.nt, pts.ur, pts.lr)
			drwln(gskel.ls, pts.ur, pts.lua)
			drwln(gskel.rs, pts.ur, pts.rua)
			drwln(gskel.la, pts.lua, pts.lfa)
			drwln(gskel.ra, pts.rua, pts.rfa)
			drwln(gskel.ll, pts.lr, pts.lul)
			drwln(gskel.rl, pts.lr, pts.rul)
			drwln(gskel.bh, pts.lul, pts.lll)
			drwln(gskel.rlb, pts.rul, pts.rll)
			
			for _, ln in pairs(gskel) do
				if ln.Visible then
					ln.Color = parseC(self, opt.gskelCol[1], true)
					ln.Transparency = opt.gskelCol[2]
				end
			end
		end
	else
		for _, ln in pairs(skel) do ln.Visible = false end
		for _, ln in pairs(gskel) do ln.Visible = false end
	end
end
function Esp:updateSkel()
    if not self.char or not self.onSc then return end
    local skpts = {}
    
    local hd = fc(self.char, "Head")
    local ur = fc(self.char, "UpperTorso")
    local lr = fc(self.char, "LowerTorso")
    local lua = fc(self.char, "LeftUpperArm")
    local rua = fc(self.char, "RightUpperArm")
    local lfa = fc(self.char, "LeftLowerArm")
    local rfa = fc(self.char, "RightLowerArm")
    local lul = fc(self.char, "LeftUpperLeg")
    local rul = fc(self.char, "RightUpperLeg")
    local lll = fc(self.char, "LeftLowerLeg")
    local rll = fc(self.char, "RightLowerLeg")
    
    if hd then skpts.hd = hd.CFrame.Position end
    if ur then skpts.ur = ur.CFrame.Position end
    if lr then skpts.lr = lr.CFrame.Position end
    if lua then skpts.lua = lua.CFrame.Position end
    if rua then skpts.rua = rua.CFrame.Position end
    if lfa then skpts.lfa = lfa.CFrame.Position end
    if rfa then skpts.rfa = rfa.CFrame.Position end
    if lul then skpts.lul = lul.CFrame.Position end
    if rul then skpts.rul = rul.CFrame.Position end
    if lll then skpts.lll = lll.CFrame.Position end
    if rll then skpts.rll = rll.CFrame.Position end
    
    self.skpts = skpts
end
local Cham = {}
Cham.__index = Cham

function Cham.new(p, itf)
	local self = setmetatable({}, Cham)
	self.plr = assert(p, "No player")
	self.itf = assert(itf, "No interface")
	self:init()
	return self
end

function Cham:init()
	self.hl = Instance.new("Highlight", gui)
	self.upCon = run.Heartbeat:Connect(function()
		self:Upd()
	end)
end

function Cham:Dest()
	self.upCon:Disconnect()
	self.hl:Destroy()
	cl(self)
end
function Cham:Upd()
    local hl = self.hl
    local itf = self.itf
    if not self.plr or not self.plr.Parent then
        hl.Enabled = false
        return
    end
    
    local char = itf.getChar(self.plr)
    local opt = itf.tSet[itf.isFr(self.plr) and "fr" or "en"]
    local hasUserId = pcall(function() 
        return self.plr.UserId ~= nil
    end)
    local en
    if self.plr == lp and not self.itf.allowlocal then
        en = false
    else
        en = opt.en and char and hasUserId and not
            (#itf.wlist > 0 and not fd(itf.wlist, self.plr.UserId))
    end

    hl.Enabled = en and opt.chams
    if hl.Enabled then
        hl.Adornee = char
        hl.FillColor = parseC(self, opt.chamsFCol[1])
        hl.FillTransparency = opt.chamsFCol[2]
        hl.OutlineColor = parseC(self, opt.chamsOCol[1], true)
        hl.OutlineTransparency = opt.chamsOCol[2]
        hl.DepthMode = opt.chamsVisOnly and "Occluded" or "AlwaysOnTop"
    end
end
local Inst = {}
Inst.__index = Inst

function Inst.new(i, opt)
	local self = setmetatable({}, Inst)
	self.inst = assert(i, "No instance")
	self.opt = assert(opt, "No options")
	self:init()
	return self
end

function Inst:init()
	local opt = self.opt
	opt.en = opt.en == nil and true or opt.en
	opt.txt = opt.txt or "{name}"
	opt.txtCol = opt.txtCol or { Color3.new(1,1,1), 1 }
	opt.txtOut = opt.txtOut == nil and true or opt.txtOut
	opt.txtOCol = opt.txtOCol or Color3.new()
	opt.txtSz = opt.txtSz or 13
	opt.txtFnt = opt.txtFnt or 2
	opt.limDis = opt.limDis or false
	opt.maxDis = opt.maxDis or 150

	self.txt = Drawing.new("Text")
	self.txt.Center = true

	self.rendCon = run.Heartbeat:Connect(function(dt)
		self:Ren(dt)
	end)
end

function Inst:Dest()
	self.rendCon:Disconnect()
	self.txt:Remove()
end

function Inst:Ren()
	local inst = self.inst
	if not inst or not inst.Parent then
		return self:Dest()
	end

	local txt = self.txt
	local opt = self.opt
	if not opt.en then
		txt.Visible = false
		return
	end

	local w = gp(inst).Position
	local pos, vis, dep = w2sc(w)
	if opt.limDis and dep > opt.maxDis then
		vis = false
	end

	txt.Visible = vis
	if txt.Visible then
		txt.Position = pos
		txt.Color = opt.txtCol[1]
		txt.Transparency = opt.txtCol[2]
		txt.Outline = opt.txtOut
		txt.OutlineColor = opt.txtOCol
		txt.Size = opt.txtSz
		txt.Font = opt.txtFnt
		txt.Text = opt.txt
			:gsub("{name}", inst.Name)
			:gsub("{distance}", rd(dep))
			:gsub("{position}", tostring(w))
	end
end

local Itf = {
	_loaded = false,
	_objCache = {},
	wlist = {},
	shSet = {
		tSz = 13,
		tFnt = 2,
		limDis = false,
		maxDis = 150,
		useTeam = false
	},
	allowlocal = false,
	tSet = {
		en = {
			en = false,
			box = false,
			boxCol = { Color3.new(1,0,0), 1 },
			boxO = true,
			boxOCol = { Color3.new(), 1 },
			boxF = false,
			boxFCol = { Color3.new(1,0,0), 0.5 },
			hb = false,
			hlCol = Color3.new(0,1,0),
			dyCol = Color3.new(1,0,0),
			hbo = true,
			
			hboCol = { Color3.new(), 0.5 },
			ht = false,
			htCol = { Color3.new(1,1,1), 1 },
			htOut = true,
			htOCol = Color3.new(),
			ab = false,
			abCol = { Color3.fromRGB(0, 150, 255), 1 },
			abo = true,
			aboCol = { Color3.new(), 0.5 },
			at = false,
			atCol = { Color3.new(1,1,1), 1 },
			atOut = true,
			atOCol = Color3.new(),
			b3d = false,
			b3dCol = { Color3.new(1,0,0), 1 },
			name = false,
			nCol = { Color3.new(1,1,1), 1 },
			nOut = true,
			nOCol = Color3.new(),
			wep = false,
			wCol = { Color3.new(1,1,1), 1 },
			wOut = true,
			wOCol = Color3.new(),
			dis = false,
			dCol = { Color3.new(1,1,1), 1 },
			dOut = true,
			dOCol = Color3.new(),
			tr = false,
			trOrg = "Bottom",
			trCol = { Color3.new(1,0,0), 1 },
			tro = true,
			troCol = { Color3.new(), 1 },
			offAr = false,
			offArCol = { Color3.new(1,1,1), 1 },
			offArSz = 15,
			offArRad = 150,
			offArO = true,
			offArOCol = { Color3.new(), 1 },
			chams = false,
			chamsVisOnly = false,
			chamsFCol = { Color3.new(0.2, 0.2, 0.2), 0.5 },
			chamsOCol = { Color3.new(1,0,0), 0 },
			skel = false,
			skelCol = { Color3.new(1,1,1), 1 },
			gskel = false,
			gskelCol = { Color3.new(1,0,0), 0.5 },

		},
		fr = {
			en = false,
			box = false,
			boxCol = { Color3.new(0,1,0), 1 },
			boxO = true,
			boxOCol = { Color3.new(), 1 },
			boxF = false,
			boxFCol = { Color3.new(0,1,0), 0.5 },
			hb = false,
			hlCol = Color3.new(0,1,0),
			dyCol = Color3.new(1,0,0),
			hbo = true,
			hboCol = { Color3.new(), 0.5 },
			ht = false,
			htCol = { Color3.new(1,1,1), 1 },
			htOut = true,
			htOCol = Color3.new(),
			b3d = false,
			b3dCol = { Color3.new(0,1,0), 1 },
			name = false,
			nCol = { Color3.new(1,1,1), 1 },
			nOut = true,
			nOCol = Color3.new(),
			wep = false,
			wCol = { Color3.new(1,1,1), 1 },
			wOut = true,
			wOCol = Color3.new(),
			dis = false,
			dCol = { Color3.new(1,1,1), 1 },
			dOut = true,
			dOCol = Color3.new(),
			tr = false,
			trOrg = "Bottom",
			trCol = { Color3.new(0,1,0), 1 },
			tro = true,
			troCol = { Color3.new(), 1 },
			offAr = false,
			offArCol = { Color3.new(1,1,1), 1 },
			offArSz = 15,
			offArRad = 150,
			offArO = true,
			offArOCol = { Color3.new(), 1 },
			chams = false,
			chamsVisOnly = false,
			chamsFCol = { Color3.new(0.2, 0.2, 0.2), 0.5 },
			chamsOCol = { Color3.new(0,1,0), 0 }
		}
	}
}

function Itf.AddInst(i, opt)
	local c = Itf._objCache
	if c[i] then
		warn("Instance handler exists.")
	else
		c[i] = { Inst.new(i, opt) }
	end
	return c[i][1]
end

function Itf.Load()
	assert(not Itf._loaded, "Already loaded.")

	local function add(p)
		Itf._objCache[p] = {
			Esp.new(p, Itf),
			Cham.new(p, Itf)
		}
	end

	local function rem(p)
		local o = Itf._objCache[p]
		if o then
			for i = 1, #o do
				o[i]:Dest()
			end
			Itf._objCache[p] = nil
		end
	end

	local ps = plrs:GetPlayers()
	for i = 1, #ps do
		add(ps[i])
	end

	Itf.pAdd = plrs.PlayerAdded:Connect(add)
	Itf.pRem = plrs.PlayerRemoving:Connect(rem)
	Itf._loaded = true
end

function Itf.Unload()
	assert(Itf._loaded, "Not loaded.")

	for idx, o in next, Itf._objCache do
		for i = 1, #o do
			o[i]:Dest()
		end
		Itf._objCache[idx] = nil
	end

	Itf.pAdd:Disconnect()
	Itf.pRem:Disconnect()
	Itf._loaded = false
end

function Itf.getWep(p)
	return "Unknown"
end

function Itf.isFr(p)
	return p.Team and p.Team == lp.Team
end

function Itf.getTC(p)
	return p.Team and p.Team.TeamColor and p.Team.TeamColor.Color
end

function Itf.getChar(p)
	return p.Character
end

function Itf.getHp(p)
	local char = p and Itf.getChar(p)
	local hum = char and fcc(char, "Humanoid")
	if hum then
		return hum.Health, hum.MaxHealth
	end
	return 100, 100
end

function Itf.getArm(p)
    local char = p and Itf.getChar(p)
    if char then
        local be = char:FindFirstChild("BodyEffects")
        if be then
            local arm = be:FindFirstChild("Armor")
            if arm then
                return arm.Value
            end
        end
    end
    return 0
end

return Itf
