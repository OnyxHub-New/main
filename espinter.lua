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
local AT_OFF = Vector2.new(3, 0)
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
	local s = setmetatable({}, Esp)
	s.plr = assert(p, "No player")
	s.itf = assert(itf, "No interface")
	s:init()
	return s
end

function Esp:_c(cls, props)
	local d = Drawing.new(cls)
	for prop, val in next, props do
		pcall(function() d[prop] = val end)
	end
	s.bin[#s.bin + 1] = d
	return d
end

function Esp:init()
	s.charCache = {}
	s.childCnt = 0
	s.bin = {}
	s.draw = {
		b3d = {
			{ s:_c("Line", { Thick = 1, Vis = false }),
			  s:_c("Line", { Thick = 1, Vis = false }),
			  s:_c("Line", { Thick = 1, Vis = false }) },
			{ s:_c("Line", { Thick = 1, Vis = false }),
			  s:_c("Line", { Thick = 1, Vis = false }),
			  s:_c("Line", { Thick = 1, Vis = false }) },
			{ s:_c("Line", { Thick = 1, Vis = false }),
			  s:_c("Line", { Thick = 1, Vis = false }),
			  s:_c("Line", { Thick = 1, Vis = false }) },
			{ s:_c("Line", { Thick = 1, Vis = false }),
			  s:_c("Line", { Thick = 1, Vis = false }),
			  s:_c("Line", { Thick = 1, Vis = false }) }
		},
		v = {
			tro = s:_c("Line", { Thick = 3, Vis = false }),
			tr = s:_c("Line", { Thick = 1, Vis = false }),
			bf = s:_c("Square", { Fill = true, Vis = false }),
			bo = s:_c("Square", { Thick = 3, Vis = false }),
			b = s:_c("Square", { Thick = 1, Vis = false }),
			hbo = s:_c("Line", { Thick = 3, Vis = false }),
			hb = s:_c("Line", { Thick = 1, Vis = false }),
			ht = s:_c("Text", { Center = true, Vis = false }),
			n = s:_c("Text", { Text = s.plr.DisplayName, Center = true, Vis = false }),
			d = s:_c("Text", { Center = true, Vis = false }),
			w = s:_c("Text", { Center = true, Vis = false }),
			abo = s:_c("Line", { Thick = 3, Vis = false }),
			ab = s:_c("Line", { Thick = 1, Vis = false }),
			at = s:_c("Text", { Center = true, Vis = false }),
		},
		h = {
			aro = s:_c("Triangle", { Thick = 3, Vis = false }),
			ar = s:_c("Triangle", { Fill = true, Vis = false })
		}
	}

	s.rendCon = run.Heartbeat:Connect(function(dt)
		s:Upd(dt)
		s:Ren(dt)
	end)
end

function Esp:Dest()
	s.rendCon:Disconnect()
	for i = 1, #s.bin do
		s.bin[i]:Remove()
	end
	cl(s)
end

function Esp:Upd()
	local itf = s.itf
	s.opt = itf.tSet[itf.isFr(s.plr) and "fr" or "en"]
	s.char = itf.getChar(s.plr)
	s.hp, s.maxHp = itf.getHp(s.plr)
	s.arm = itf.getArm(s.plr)
	s.wep = itf.getWep(s.plr)
	s.en = s.opt.en and s.char and not (#itf.wlist > 0 and not fd(itf.wlist, s.plr.UserId))

	local hd = s.en and fc(s.char, "Head")
	if not hd then
		s.charCache = {}
		s.onSc = false
		return
	end

	local _, onSc, dep = w2sc(hd.Position)
	s.onSc = onSc
	s.dis = dep

	if itf.shSet.limDis and dep > itf.shSet.maxDis then
		s.onSc = false
	end

	if s.onSc then
		local ch = s.charCache
		local kids = gc(s.char)
		if not ch[1] or s.childCnt ~= #kids then
			cl(ch)
			for i = 1, #kids do
				local p = kids[i]
				if isA(p, "BasePart") and isBP(p.Name) then
					ch[#ch + 1] = p
				end
			end
			s.childCnt = #kids
		end
		s.corn = calcCorn(getBB(ch))
	elseif s.opt.offAr then
		local cf = cam.CFrame
		local flt = fm(cf.Position, cf.RightVector, Vector3.yAxis)
		local obj = pos(flt, hd.Position)
		s.dir = Vector2.new(obj.X, obj.Z).Unit
	end
end

function Esp:Ren()
	local onSc = s.onSc or false
	local en = s.en or false
	local v = s.draw.v
	local h = s.draw.h
	local b3d = s.draw.b3d
	local itf = s.itf
	local opt = s.opt
	local corn = s.corn

	v.b.Vis = en and onSc and opt.box
	v.bo.Vis = v.b.Vis and opt.boxO
	if v.b.Vis then
		local b = v.b
		b.Pos = corn.tl
		b.Size = corn.br - corn.tl
		b.Col = parseC(s, opt.boxCol[1])
		b.Trans = opt.boxCol[2]

		local bo = v.bo
		bo.Pos = b.Pos
		bo.Size = b.Size
		bo.Col = parseC(s, opt.boxOCol[1], true)
		bo.Trans = opt.boxOCol[2]
	end

	v.bf.Vis = en and onSc and opt.boxF
	if v.bf.Vis then
		local bf = v.bf
		bf.Pos = corn.tl
		bf.Size = corn.br - corn.tl
		bf.Col = parseC(s, opt.boxFCol[1])
		bf.Trans = opt.boxFCol[2]
	end

	v.hb.Vis = en and onSc and opt.hb
	v.hbo.Vis = v.hb.Vis and opt.hbo
	if v.hb.Vis then
		local fr = corn.tl - HB_OFF
		local to = corn.bl - HB_OFF

		local hb = v.hb
		hb.To = to
		hb.From = l2(to, fr, s.hp/s.maxHp)
		hb.Col = lc(opt.dyCol, opt.hlCol, s.hp/s.maxHp)

		local hbo = v.hbo
		hbo.To = to + HO_OFF
		hbo.From = fr - HO_OFF
		hbo.Col = parseC(s, opt.hboCol[1], true)
		hbo.Trans = opt.hboCol[2]
	end

	v.ht.Vis = en and onSc and opt.ht
	if v.ht.Vis then
		local fr = corn.tl - HB_OFF
		local to = corn.bl - HB_OFF

		local ht = v.ht
		ht.Text = rd(s.hp) .. "hp"
		ht.Size = itf.shSet.tSz
		ht.Font = itf.shSet.tFnt
		ht.Col = parseC(s, opt.htCol[1])
		ht.Trans = opt.htCol[2]
		ht.Out = opt.htOut
		ht.OutCol = parseC(s, opt.htOCol, true)
		ht.Pos = l2(to, fr, s.hp/s.maxHp) - ht.TextBounds*0.5 - HT_OFF
	end

	v.ab.Vis = en and onSc and opt.ab
	v.abo.Vis = v.ab.Vis and opt.abo
	if v.ab.Vis then
		local fr = corn.tr + AB_OFF
		local to = corn.br + AB_OFF
		local maxArm = 200

		local ab = v.ab
		ab.To = to
		ab.From = l2(to, fr, s.arm/maxArm)
		ab.Col = opt.abCol[1]

		local abo = v.abo
		abo.To = to + AO_OFF
		abo.From = fr - AO_OFF
		abo.Col = parseC(s, opt.aboCol[1], true)
		abo.Trans = opt.aboCol[2]
	end

	v.at.Vis = en and onSc and opt.at
	if v.at.Vis then
		local fr = corn.tr + AB_OFF
		local to = corn.br + AB_OFF
		local maxArm = 200

		local at = v.at
		at.Text = rd(s.arm) .. "ap"
		at.Size = itf.shSet.tSz
		at.Font = itf.shSet.tFnt
		at.Col = parseC(s, opt.atCol[1])
		at.Trans = opt.atCol[2]
		at.Out = opt.atOut
		at.OutCol = parseC(s, opt.atOCol, true)
		at.Pos = l2(to, fr, s.arm/maxArm) - at.TextBounds*0.5 + AT_OFF
	end

	v.n.Vis = en and onSc and opt.name
	if v.n.Vis then
		local n = v.n
		n.Size = itf.shSet.tSz
		n.Font = itf.shSet.tFnt
		n.Col = parseC(s, opt.nCol[1])
		n.Trans = opt.nCol[2]
		n.Out = opt.nOut
		n.OutCol = parseC(s, opt.nOCol, true)
		n.Pos = (corn.tl + corn.tr)*0.5 - Vector2.yAxis*n.TextBounds.Y - N_OFF
	end

	v.d.Vis = en and onSc and s.dis and opt.dis
	if v.d.Vis then
		local d = v.d
		d.Text = rd(s.dis) .. " studs"
		d.Size = itf.shSet.tSz
		d.Font = itf.shSet.tFnt
		d.Col = parseC(s, opt.dCol[1])
		d.Trans = opt.dCol[2]
		d.Out = opt.dOut
		d.OutCol = parseC(s, opt.dOCol, true)
		d.Pos = (corn.bl + corn.br)*0.5 + D_OFF
	end

	v.w.Vis = en and onSc and opt.wep
	if v.w.Vis then
		local w = v.w
		w.Text = s.wep
		w.Size = itf.shSet.tSz
		w.Font = itf.shSet.tFnt
		w.Col = parseC(s, opt.wCol[1])
		w.Trans = opt.wCol[2]
		w.Out = opt.wOut
		w.OutCol = parseC(s, opt.wOCol, true)
		w.Pos = (corn.bl + corn.br)*0.5 + (v.d.Vis and D_OFF + Vector2.yAxis*v.d.TextBounds.Y or Vector2.zero)
	end

	v.tr.Vis = en and onSc and opt.tr
	v.tro.Vis = v.tr.Vis and opt.tro
	if v.tr.Vis then
		local tr = v.tr
		tr.Col = parseC(s, opt.trCol[1])
		tr.Trans = opt.trCol[2]
		tr.To = (corn.bl + corn.br)*0.5
		tr.From =
			opt.trOrg == "Middle" and vs*0.5 or
			opt.trOrg == "Top" and vs*Vector2.new(0.5, 0) or
			opt.trOrg == "Bottom" and vs*Vector2.new(0.5, 1)

		local tro = v.tro
		tro.Col = parseC(s, opt.troCol[1], true)
		tro.Trans = opt.troCol[2]
		tro.To = tr.To
		tro.From = tr.From
	end

	h.ar.Vis = en and (not onSc) and opt.offAr
	h.aro.Vis = h.ar.Vis and opt.offArO
	if h.ar.Vis and s.dir then
		local ar = h.ar
		ar.PointA = m2(m2x(vs*0.5 + s.dir*opt.offArRad, Vector2.one*25), vs - Vector2.one*25)
		ar.PointB = ar.PointA - rotV(s.dir, 0.45)*opt.offArSz
		ar.PointC = ar.PointA - rotV(s.dir, -0.45)*opt.offArSz
		ar.Col = parseC(s, opt.offArCol[1])
		ar.Trans = opt.offArCol[2]

		local aro = h.aro
		aro.PointA = ar.PointA
		aro.PointB = ar.PointB
		aro.PointC = ar.PointC
		aro.Col = parseC(s, opt.offArOCol[1], true)
		aro.Trans = opt.offArOCol[2]
	end

	local b3dEn = en and onSc and opt.b3d
	for i = 1, #b3d do
		local f = b3d[i]
		for i2 = 1, #f do
			local ln = f[i2]
			ln.Vis = b3dEn
			ln.Col = parseC(s, opt.b3dCol[1])
			ln.Trans = opt.b3dCol[2]
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
end

local Cham = {}
Cham.__index = Cham

function Cham.new(p, itf)
	local s = setmetatable({}, Cham)
	s.plr = assert(p, "No player")
	s.itf = assert(itf, "No interface")
	s:init()
	return s
end

function Cham:init()
	s.hl = Instance.new("Highlight", gui)
	s.upCon = run.Heartbeat:Connect(function()
		s:Upd()
	end)
end

function Cham:Dest()
	s.upCon:Disconnect()
	s.hl:Destroy()
	cl(s)
end

function Cham:Upd()
	local hl = s.hl
	local itf = s.itf
	local char = itf.getChar(s.plr)
	local opt = itf.tSet[itf.isFr(s.plr) and "fr" or "en"]
	local en = opt.en and char and not (#itf.wlist > 0 and not fd(itf.wlist, s.plr.UserId))

	hl.Enabled = en and opt.chams
	if hl.Enabled then
		hl.Adornee = char
		hl.FillCol = parseC(s, opt.chamsFCol[1])
		hl.FillTrans = opt.chamsFCol[2]
		hl.OutCol = parseC(s, opt.chamsOCol[1], true)
		hl.OutTrans = opt.chamsOCol[2]
		hl.DepthMode = opt.chamsVisOnly and "Occluded" or "AlwaysOnTop"
	end
end

local Inst = {}
Inst.__index = Inst

function Inst.new(i, opt)
	local s = setmetatable({}, Inst)
	s.inst = assert(i, "No instance")
	s.opt = assert(opt, "No options")
	s:init()
	return s
end

function Inst:init()
	local opt = s.opt
	opt.en = opt.en == nil and true or opt.en
	opt.txt = opt.txt or "{name}"
	opt.txtCol = opt.txtCol or { Color3.new(1,1,1), 1 }
	opt.txtOut = opt.txtOut == nil and true or opt.txtOut
	opt.txtOCol = opt.txtOCol or Color3.new()
	opt.txtSz = opt.txtSz or 13
	opt.txtFnt = opt.txtFnt or 2
	opt.limDis = opt.limDis or false
	opt.maxDis = opt.maxDis or 150

	s.txt = Drawing.new("Text")
	s.txt.Center = true

	s.rendCon = run.Heartbeat:Connect(function(dt)
		s:Ren(dt)
	end)
end

function Inst:Dest()
	s.rendCon:Disconnect()
	s.txt:Remove()
end

function Inst:Ren()
	local inst = s.inst
	if not inst or not inst.Parent then
		return s:Dest()
	end

	local txt = s.txt
	local opt = s.opt
	if not opt.en then
		txt.Vis = false
		return
	end

	local w = gp(inst).Position
	local pos, vis, dep = w2sc(w)
	if opt.limDis and dep > opt.maxDis then
		vis = false
	end

	txt.Vis = vis
	if txt.Vis then
		txt.Pos = pos
		txt.Col = opt.txtCol[1]
		txt.Trans = opt.txtCol[2]
		txt.Out = opt.txtOut
		txt.OutCol = opt.txtOCol
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
			atCol = { Color3.fromRGB(0, 150, 255), 1 },
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
	for i = 2, #ps do
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
