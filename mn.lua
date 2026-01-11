--[[
    		Airflow Interface

    Author: 4lpaca
    License: MIT
    Github: https://github.com/4lpaca-pin/Airflow
--]]

-- Type --
export type GlobalConfig = {
	Name: string,
	Callback: (... any) -> any,
	Default : boolean & string & number & {string&any} & Enum.KeyCode,
	Min : number,
	Max : number,
	Round : number,
	Type : string,
	Content : string,
	Values : {string},
	Multi : boolean,
	Position : string,
	Numeric : boolean,
	Finished : boolean,
	Placeholder : string,
	ValueTexts : {
		[number]:string
	}
};

export type Elements = {
	AddLabel : (self, name) -> {
		Edit : (self, Value: string) -> nil,
		Visible : (self, Value: boolean) -> nil,
		Destroy : (self) -> nil,
	},
	AddButton : (self,config : GlobalConfig) -> {
		Edit : (self, Value: string) -> nil,
		Visible : (self, Value: boolean) -> nil,
		Destroy : (self) -> nil,
		Fire : (... any) -> any,
	},
	AddToggle : (self,config : GlobalConfig) -> {
		Edit : (self, Value: string) -> nil,
		Visible : (self, Value: boolean) -> nil,
		Destroy : (self) -> nil,
		SetValue : (self,Value : boolean) -> any,
		AutomaticVisible : (self , config : {
			Target : boolean ,
			Elements : {Elements}
		}) -> RBXScriptSignal,
	},
	AddSlider : (self,config : GlobalConfig) -> {
		Edit : (self, Value: string) -> nil,
		Visible : (self, Value: boolean) -> nil,
		Destroy : (self) -> nil,
		SetValue : (self,Value : number) -> any,
	},
	AddKeybind : (self,config : GlobalConfig) -> {
		Edit : (self, Value: string) -> nil,
		Visible : (self , Value: boolean) -> nil,
		Destroy : (self) -> nil,
		SetValue : (self ,Value : string & Enum.KeyCode) -> any,
	},
	AddTextbox : (self,config : GlobalConfig) -> {
		Edit : (self, Value: string) -> nil,
		Visible : (self , Value: boolean) -> nil,
		Destroy : (self) -> nil,
		SetValue : (self ,Value : string) -> any,
	},
	AddColorPicker : (self,config : GlobalConfig) -> {
		Edit : (self, Value: string) -> nil,
		SetValue : (self, Value: Color3) -> nil,
		Visible : (self , Value: boolean) -> nil,
		Destroy : (self) -> nil,
	},
	AddParagraph : (self,config : GlobalConfig) -> {
		EditName : (self, Value: string) -> nil,
		EditContent : (self, Value: string) -> nil,
		Visible : (self , Value: boolean) -> nil,
		Destroy : (self) -> nil,
	},
	AddDropdown : (self, config : GlobalConfig) -> {
		Edit : (self, Value: string) -> nil,
		SetValues : (self , Value: {string}) -> nil,
		SetDefault : (self , Value: {string} & string) -> nil,
		Visible : (self , Value: boolean) -> nil,
		Destroy : (self) -> nil,
	},
};

export type Tab = {
	Left : Elements,
	Right : Elements,
	AddSection : (self , GlobalConfig) -> Elements,
	Disabled : boolean,
	Disable : (self, Value: boolean , Reason : string & nil) -> any,
};

export type KeyValue = {
	Visible : (self , Value: boolean) -> any,
	SetKey : (self , Value: string) -> any,
	SetValue : (self , Value: string) -> any,
}

export type LoaderVersion = {
	Name : string,
	Status : string,
	LastUpdate : number | string,
	LoadScript : string | (any) -> any,
};


export type Loader = {
	Name : string,
	Icon : string,
	Hightlight : Color3,
	DrawGame : (loader_game : LoaderGame) -> {
		DrawVersion : (loader_version : LoaderVersion) -> LoaderVersion,
	},
};

export type LoaderGame = {
	Name : string,
	Logo : string,
	Description : string,
	DrawVersion : (loader_version : LoaderVersion) -> nil,
};

-- Exploit Environment --
cloneref = cloneref or function(i) return i; end;
cloenfunction = cloenfunction or function(...) return ...; end;
hookfunction = hookfunction or function(a,b) return a; end;
getgenv = getgenv or getfenv;
protect_gui = protect_gui or protectgui or (syn and syn.protect_gui) or function() end;

-- Services --
local TextService = game:GetService('TextService');
local TweenService = game:GetService('TweenService');
local RunService = game:GetService('RunService');
local Players = game:GetService('Players');
local UserInputService = game:GetService('UserInputService');
local Client = Players.LocalPlayer;
local Mouse = Client:GetMouse();
local CurrentCamera = workspace.CurrentCamera;
local AirflowUI = Instance.new("ScreenGui");
local _,CoreGui = xpcall(function()
	return (gethui and gethui()) or game:GetService("CoreGui"):FindFirstChild("RobloxGui");
end,function()
	return Client.PlayerGui;
end);

do
	AirflowUI.Name = "AirflowUI";
	AirflowUI.Parent = CoreGui;
	AirflowUI.ResetOnSpawn = false;
	AirflowUI.ZIndexBehavior = Enum.ZIndexBehavior.Global;
	AirflowUI.IgnoreGuiInset = true;

	protect_gui(AirflowUI);
end;

-- Airflow --
local Airflow = {
	Version = "1.2",
	ScreenGui = AirflowUI,
	Config = {
		Scale = UDim2.new(0.1, 515, 0.1, (UserInputService.TouchEnabled and 345) or 395),
		Hightlight = Color3.fromRGB(163, 128, 216),
		Logo = "http://www.roblox.com/asset/?id=118752982916680",
		Keybind = "Delete",
		Resizable = false,
		UnlockMouse = false,
		IconSize = 20,
	},
	FileManager = {},
	Features = {},
	Lucide = {
		["lucide-accessibility"] = "rbxassetid://10709751939",
		["lucide-activity"] = "rbxassetid://10709752035",
		["lucide-air-vent"] = "rbxassetid://10709752131",
		["lucide-airplay"] = "rbxassetid://10709752254",
		["lucide-alarm-check"] = "rbxassetid://10709752405",
		["lucide-alarm-clock"] = "rbxassetid://10709752630",
		["lucide-alarm-clock-off"] = "rbxassetid://10709752508",
		["lucide-alarm-minus"] = "rbxassetid://10709752732",
		["lucide-alarm-plus"] = "rbxassetid://10709752825",
		["lucide-album"] = "rbxassetid://10709752906",
		["lucide-alert-circle"] = "rbxassetid://10709752996",
		["lucide-alert-octagon"] = "rbxassetid://10709753064",
		["lucide-alert-triangle"] = "rbxassetid://10709753149",
		["lucide-align-center"] = "rbxassetid://10709753570",
		["lucide-align-center-horizontal"] = "rbxassetid://10709753272",
		["lucide-align-center-vertical"] = "rbxassetid://10709753421",
		["lucide-align-end-horizontal"] = "rbxassetid://10709753692",
		["lucide-align-end-vertical"] = "rbxassetid://10709753808",
		["lucide-align-horizontal-distribute-center"] = "rbxassetid://10747779791",
		["lucide-align-horizontal-distribute-end"] = "rbxassetid://10747784534",
		["lucide-align-horizontal-distribute-start"] = "rbxassetid://10709754118",
		["lucide-align-horizontal-justify-center"] = "rbxassetid://10709754204",
		["lucide-align-horizontal-justify-end"] = "rbxassetid://10709754317",
		["lucide-align-horizontal-justify-start"] = "rbxassetid://10709754436",
		["lucide-align-horizontal-space-around"] = "rbxassetid://10709754590",
		["lucide-align-horizontal-space-between"] = "rbxassetid://10709754749",
		["lucide-align-justify"] = "rbxassetid://10709759610",
		["lucide-align-left"] = "rbxassetid://10709759764",
		["lucide-align-right"] = "rbxassetid://10709759895",
		["lucide-align-start-horizontal"] = "rbxassetid://10709760051",
		["lucide-align-start-vertical"] = "rbxassetid://10709760244",
		["lucide-align-vertical-distribute-center"] = "rbxassetid://10709760351",
		["lucide-align-vertical-distribute-end"] = "rbxassetid://10709760434",
		["lucide-align-vertical-distribute-start"] = "rbxassetid://10709760612",
		["lucide-align-vertical-justify-center"] = "rbxassetid://10709760814",
		["lucide-align-vertical-justify-end"] = "rbxassetid://10709761003",
		["lucide-align-vertical-justify-start"] = "rbxassetid://10709761176",
		["lucide-align-vertical-space-around"] = "rbxassetid://10709761324",
		["lucide-align-vertical-space-between"] = "rbxassetid://10709761434",
		["lucide-anchor"] = "rbxassetid://10709761530",
		["lucide-angry"] = "rbxassetid://10709761629",
		["lucide-annoyed"] = "rbxassetid://10709761722",
		["lucide-aperture"] = "rbxassetid://10709761813",
		["lucide-apple"] = "rbxassetid://10709761889",
		["lucide-archive"] = "rbxassetid://10709762233",
		["lucide-archive-restore"] = "rbxassetid://10709762058",
		["lucide-armchair"] = "rbxassetid://10709762327",
		["lucide-arrow-big-down"] = "rbxassetid://10747796644",
		["lucide-arrow-big-left"] = "rbxassetid://10709762574",
		["lucide-arrow-big-right"] = "rbxassetid://10709762727",
		["lucide-arrow-big-up"] = "rbxassetid://10709762879",
		["lucide-arrow-down"] = "rbxassetid://10709767827",
		["lucide-arrow-down-circle"] = "rbxassetid://10709763034",
		["lucide-arrow-down-left"] = "rbxassetid://10709767656",
		["lucide-arrow-down-right"] = "rbxassetid://10709767750",
		["lucide-arrow-left"] = "rbxassetid://10709768114",
		["lucide-arrow-left-circle"] = "rbxassetid://10709767936",
		["lucide-arrow-left-right"] = "rbxassetid://10709768019",
		["lucide-arrow-right"] = "rbxassetid://10709768347",
		["lucide-arrow-right-circle"] = "rbxassetid://10709768226",
		["lucide-arrow-up"] = "rbxassetid://10709768939",
		["lucide-arrow-up-circle"] = "rbxassetid://10709768432",
		["lucide-arrow-up-down"] = "rbxassetid://10709768538",
		["lucide-arrow-up-left"] = "rbxassetid://10709768661",
		["lucide-arrow-up-right"] = "rbxassetid://10709768787",
		["lucide-asterisk"] = "rbxassetid://10709769095",
		["lucide-at-sign"] = "rbxassetid://10709769286",
		["lucide-award"] = "rbxassetid://10709769406",
		["lucide-axe"] = "rbxassetid://10709769508",
		["lucide-axis-3d"] = "rbxassetid://10709769598",
		["lucide-baby"] = "rbxassetid://10709769732",
		["lucide-backpack"] = "rbxassetid://10709769841",
		["lucide-baggage-claim"] = "rbxassetid://10709769935",
		["lucide-banana"] = "rbxassetid://10709770005",
		["lucide-banknote"] = "rbxassetid://10709770178",
		["lucide-bar-chart"] = "rbxassetid://10709773755",
		["lucide-bar-chart-2"] = "rbxassetid://10709770317",
		["lucide-bar-chart-3"] = "rbxassetid://10709770431",
		["lucide-bar-chart-4"] = "rbxassetid://10709770560",
		["lucide-bar-chart-horizontal"] = "rbxassetid://10709773669",
		["lucide-barcode"] = "rbxassetid://10747360675",
		["lucide-baseline"] = "rbxassetid://10709773863",
		["lucide-bath"] = "rbxassetid://10709773963",
		["lucide-battery"] = "rbxassetid://10709774640",
		["lucide-battery-charging"] = "rbxassetid://10709774068",
		["lucide-battery-full"] = "rbxassetid://10709774206",
		["lucide-battery-low"] = "rbxassetid://10709774370",
		["lucide-battery-medium"] = "rbxassetid://10709774513",
		["lucide-beaker"] = "rbxassetid://10709774756",
		["lucide-bed"] = "rbxassetid://10709775036",
		["lucide-bed-double"] = "rbxassetid://10709774864",
		["lucide-bed-single"] = "rbxassetid://10709774968",
		["lucide-beer"] = "rbxassetid://10709775167",
		["lucide-bell"] = "rbxassetid://10709775704",
		["lucide-bell-minus"] = "rbxassetid://10709775241",
		["lucide-bell-off"] = "rbxassetid://10709775320",
		["lucide-bell-plus"] = "rbxassetid://10709775448",
		["lucide-bell-ring"] = "rbxassetid://10709775560",
		["lucide-bike"] = "rbxassetid://10709775894",
		["lucide-binary"] = "rbxassetid://10709776050",
		["lucide-bitcoin"] = "rbxassetid://10709776126",
		["lucide-bluetooth"] = "rbxassetid://10709776655",
		["lucide-bluetooth-connected"] = "rbxassetid://10709776240",
		["lucide-bluetooth-off"] = "rbxassetid://10709776344",
		["lucide-bluetooth-searching"] = "rbxassetid://10709776501",
		["lucide-bold"] = "rbxassetid://10747813908",
		["lucide-bomb"] = "rbxassetid://10709781460",
		["lucide-bone"] = "rbxassetid://10709781605",
		["lucide-book"] = "rbxassetid://10709781824",
		["lucide-book-open"] = "rbxassetid://10709781717",
		["lucide-bookmark"] = "rbxassetid://10709782154",
		["lucide-bookmark-minus"] = "rbxassetid://10709781919",
		["lucide-bookmark-plus"] = "rbxassetid://10709782044",
		["lucide-bot"] = "rbxassetid://10709782230",
		["lucide-box"] = "rbxassetid://10709782497",
		["lucide-box-select"] = "rbxassetid://10709782342",
		["lucide-boxes"] = "rbxassetid://10709782582",
		["lucide-briefcase"] = "rbxassetid://10709782662",
		["lucide-brush"] = "rbxassetid://10709782758",
		["lucide-bug"] = "rbxassetid://10709782845",
		["lucide-building"] = "rbxassetid://10709783051",
		["lucide-building-2"] = "rbxassetid://10709782939",
		["lucide-bus"] = "rbxassetid://10709783137",
		["lucide-cake"] = "rbxassetid://10709783217",
		["lucide-calculator"] = "rbxassetid://10709783311",
		["lucide-calendar"] = "rbxassetid://10709789505",
		["lucide-calendar-check"] = "rbxassetid://10709783474",
		["lucide-calendar-check-2"] = "rbxassetid://10709783392",
		["lucide-calendar-clock"] = "rbxassetid://10709783577",
		["lucide-calendar-days"] = "rbxassetid://10709783673",
		["lucide-calendar-heart"] = "rbxassetid://10709783835",
		["lucide-calendar-minus"] = "rbxassetid://10709783959",
		["lucide-calendar-off"] = "rbxassetid://10709788784",
		["lucide-calendar-plus"] = "rbxassetid://10709788937",
		["lucide-calendar-range"] = "rbxassetid://10709789053",
		["lucide-calendar-search"] = "rbxassetid://10709789200",
		["lucide-calendar-x"] = "rbxassetid://10709789407",
		["lucide-calendar-x-2"] = "rbxassetid://10709789329",
		["lucide-camera"] = "rbxassetid://10709789686",
		["lucide-camera-off"] = "rbxassetid://10747822677",
		["lucide-car"] = "rbxassetid://10709789810",
		["lucide-carrot"] = "rbxassetid://10709789960",
		["lucide-cast"] = "rbxassetid://10709790097",
		["lucide-charge"] = "rbxassetid://10709790202",
		["lucide-check"] = "rbxassetid://10709790644",
		["lucide-check-circle"] = "rbxassetid://10709790387",
		["lucide-check-circle-2"] = "rbxassetid://10709790298",
		["lucide-check-square"] = "rbxassetid://10709790537",
		["lucide-chef-hat"] = "rbxassetid://10709790757",
		["lucide-cherry"] = "rbxassetid://10709790875",
		["lucide-chevron-down"] = "rbxassetid://10709790948",
		["lucide-chevron-first"] = "rbxassetid://10709791015",
		["lucide-chevron-last"] = "rbxassetid://10709791130",
		["lucide-chevron-left"] = "rbxassetid://10709791281",
		["lucide-chevron-right"] = "rbxassetid://10709791437",
		["lucide-chevron-up"] = "rbxassetid://10709791523",
		["lucide-chevrons-down"] = "rbxassetid://10709796864",
		["lucide-chevrons-down-up"] = "rbxassetid://10709791632",
		["lucide-chevrons-left"] = "rbxassetid://10709797151",
		["lucide-chevrons-left-right"] = "rbxassetid://10709797006",
		["lucide-chevrons-right"] = "rbxassetid://10709797382",
		["lucide-chevrons-right-left"] = "rbxassetid://10709797274",
		["lucide-chevrons-up"] = "rbxassetid://10709797622",
		["lucide-chevrons-up-down"] = "rbxassetid://10709797508",
		["lucide-chrome"] = "rbxassetid://10709797725",
		["lucide-circle"] = "rbxassetid://10709798174",
		["lucide-circle-dot"] = "rbxassetid://10709797837",
		["lucide-circle-ellipsis"] = "rbxassetid://10709797985",
		["lucide-circle-slashed"] = "rbxassetid://10709798100",
		["lucide-citrus"] = "rbxassetid://10709798276",
		["lucide-clapperboard"] = "rbxassetid://10709798350",
		["lucide-clipboard"] = "rbxassetid://10709799288",
		["lucide-clipboard-check"] = "rbxassetid://10709798443",
		["lucide-clipboard-copy"] = "rbxassetid://10709798574",
		["lucide-clipboard-edit"] = "rbxassetid://10709798682",
		["lucide-clipboard-list"] = "rbxassetid://10709798792",
		["lucide-clipboard-signature"] = "rbxassetid://10709798890",
		["lucide-clipboard-type"] = "rbxassetid://10709798999",
		["lucide-clipboard-x"] = "rbxassetid://10709799124",
		["lucide-clock"] = "rbxassetid://10709805144",
		["lucide-clock-1"] = "rbxassetid://10709799535",
		["lucide-clock-10"] = "rbxassetid://10709799718",
		["lucide-clock-11"] = "rbxassetid://10709799818",
		["lucide-clock-12"] = "rbxassetid://10709799962",
		["lucide-clock-2"] = "rbxassetid://10709803876",
		["lucide-clock-3"] = "rbxassetid://10709803989",
		["lucide-clock-4"] = "rbxassetid://10709804164",
		["lucide-clock-5"] = "rbxassetid://10709804291",
		["lucide-clock-6"] = "rbxassetid://10709804435",
		["lucide-clock-7"] = "rbxassetid://10709804599",
		["lucide-clock-8"] = "rbxassetid://10709804784",
		["lucide-clock-9"] = "rbxassetid://10709804996",
		["lucide-cloud"] = "rbxassetid://10709806740",
		["lucide-cloud-cog"] = "rbxassetid://10709805262",
		["lucide-cloud-drizzle"] = "rbxassetid://10709805371",
		["lucide-cloud-fog"] = "rbxassetid://10709805477",
		["lucide-cloud-hail"] = "rbxassetid://10709805596",
		["lucide-cloud-lightning"] = "rbxassetid://10709805727",
		["lucide-cloud-moon"] = "rbxassetid://10709805942",
		["lucide-cloud-moon-rain"] = "rbxassetid://10709805838",
		["lucide-cloud-off"] = "rbxassetid://10709806060",
		["lucide-cloud-rain"] = "rbxassetid://10709806277",
		["lucide-cloud-rain-wind"] = "rbxassetid://10709806166",
		["lucide-cloud-snow"] = "rbxassetid://10709806374",
		["lucide-cloud-sun"] = "rbxassetid://10709806631",
		["lucide-cloud-sun-rain"] = "rbxassetid://10709806475",
		["lucide-cloudy"] = "rbxassetid://10709806859",
		["lucide-clover"] = "rbxassetid://10709806995",
		["lucide-code"] = "rbxassetid://10709810463",
		["lucide-code-2"] = "rbxassetid://10709807111",
		["lucide-codepen"] = "rbxassetid://10709810534",
		["lucide-codesandbox"] = "rbxassetid://10709810676",
		["lucide-coffee"] = "rbxassetid://10709810814",
		["lucide-cog"] = "rbxassetid://10709810948",
		["lucide-coins"] = "rbxassetid://10709811110",
		["lucide-columns"] = "rbxassetid://10709811261",
		["lucide-command"] = "rbxassetid://10709811365",
		["lucide-compass"] = "rbxassetid://10709811445",
		["lucide-component"] = "rbxassetid://10709811595",
		["lucide-concierge-bell"] = "rbxassetid://10709811706",
		["lucide-connection"] = "rbxassetid://10747361219",
		["lucide-contact"] = "rbxassetid://10709811834",
		["lucide-contrast"] = "rbxassetid://10709811939",
		["lucide-cookie"] = "rbxassetid://10709812067",
		["lucide-copy"] = "rbxassetid://10709812159",
		["lucide-copyleft"] = "rbxassetid://10709812251",
		["lucide-copyright"] = "rbxassetid://10709812311",
		["lucide-corner-down-left"] = "rbxassetid://10709812396",
		["lucide-corner-down-right"] = "rbxassetid://10709812485",
		["lucide-corner-left-down"] = "rbxassetid://10709812632",
		["lucide-corner-left-up"] = "rbxassetid://10709812784",
		["lucide-corner-right-down"] = "rbxassetid://10709812939",
		["lucide-corner-right-up"] = "rbxassetid://10709813094",
		["lucide-corner-up-left"] = "rbxassetid://10709813185",
		["lucide-corner-up-right"] = "rbxassetid://10709813281",
		["lucide-cpu"] = "rbxassetid://10709813383",
		["lucide-croissant"] = "rbxassetid://10709818125",
		["lucide-crop"] = "rbxassetid://10709818245",
		["lucide-cross"] = "rbxassetid://10709818399",
		["lucide-crosshair"] = "rbxassetid://10709818534",
		["lucide-crown"] = "rbxassetid://10709818626",
		["lucide-cup-soda"] = "rbxassetid://10709818763",
		["lucide-curly-braces"] = "rbxassetid://10709818847",
		["lucide-currency"] = "rbxassetid://10709818931",
		["lucide-database"] = "rbxassetid://10709818996",
		["lucide-delete"] = "rbxassetid://10709819059",
		["lucide-diamond"] = "rbxassetid://10709819149",
		["lucide-dice-1"] = "rbxassetid://10709819266",
		["lucide-dice-2"] = "rbxassetid://10709819361",
		["lucide-dice-3"] = "rbxassetid://10709819508",
		["lucide-dice-4"] = "rbxassetid://10709819670",
		["lucide-dice-5"] = "rbxassetid://10709819801",
		["lucide-dice-6"] = "rbxassetid://10709819896",
		["lucide-dices"] = "rbxassetid://10723343321",
		["lucide-diff"] = "rbxassetid://10723343416",
		["lucide-disc"] = "rbxassetid://10723343537",
		["lucide-divide"] = "rbxassetid://10723343805",
		["lucide-divide-circle"] = "rbxassetid://10723343636",
		["lucide-divide-square"] = "rbxassetid://10723343737",
		["lucide-dollar-sign"] = "rbxassetid://10723343958",
		["lucide-download"] = "rbxassetid://10723344270",
		["lucide-download-cloud"] = "rbxassetid://10723344088",
		["lucide-droplet"] = "rbxassetid://10723344432",
		["lucide-droplets"] = "rbxassetid://10734883356",
		["lucide-drumstick"] = "rbxassetid://10723344737",
		["lucide-edit"] = "rbxassetid://10734883598",
		["lucide-edit-2"] = "rbxassetid://10723344885",
		["lucide-edit-3"] = "rbxassetid://10723345088",
		["lucide-egg"] = "rbxassetid://10723345518",
		["lucide-egg-fried"] = "rbxassetid://10723345347",
		["lucide-electricity"] = "rbxassetid://10723345749",
		["lucide-electricity-off"] = "rbxassetid://10723345643",
		["lucide-equal"] = "rbxassetid://10723345990",
		["lucide-equal-not"] = "rbxassetid://10723345866",
		["lucide-eraser"] = "rbxassetid://10723346158",
		["lucide-euro"] = "rbxassetid://10723346372",
		["lucide-expand"] = "rbxassetid://10723346553",
		["lucide-external-link"] = "rbxassetid://10723346684",
		["lucide-eye"] = "rbxassetid://10723346959",
		["lucide-eye-off"] = "rbxassetid://10723346871",
		["lucide-factory"] = "rbxassetid://10723347051",
		["lucide-fan"] = "rbxassetid://10723354359",
		["lucide-fast-forward"] = "rbxassetid://10723354521",
		["lucide-feather"] = "rbxassetid://10723354671",
		["lucide-figma"] = "rbxassetid://10723354801",
		["lucide-file"] = "rbxassetid://10723374641",
		["lucide-file-archive"] = "rbxassetid://10723354921",
		["lucide-file-audio"] = "rbxassetid://10723355148",
		["lucide-file-audio-2"] = "rbxassetid://10723355026",
		["lucide-file-axis-3d"] = "rbxassetid://10723355272",
		["lucide-file-badge"] = "rbxassetid://10723355622",
		["lucide-file-badge-2"] = "rbxassetid://10723355451",
		["lucide-file-bar-chart"] = "rbxassetid://10723355887",
		["lucide-file-bar-chart-2"] = "rbxassetid://10723355746",
		["lucide-file-box"] = "rbxassetid://10723355989",
		["lucide-file-check"] = "rbxassetid://10723356210",
		["lucide-file-check-2"] = "rbxassetid://10723356100",
		["lucide-file-clock"] = "rbxassetid://10723356329",
		["lucide-file-code"] = "rbxassetid://10723356507",
		["lucide-file-cog"] = "rbxassetid://10723356830",
		["lucide-file-cog-2"] = "rbxassetid://10723356676",
		["lucide-file-diff"] = "rbxassetid://10723357039",
		["lucide-file-digit"] = "rbxassetid://10723357151",
		["lucide-file-down"] = "rbxassetid://10723357322",
		["lucide-file-edit"] = "rbxassetid://10723357495",
		["lucide-file-heart"] = "rbxassetid://10723357637",
		["lucide-file-image"] = "rbxassetid://10723357790",
		["lucide-file-input"] = "rbxassetid://10723357933",
		["lucide-file-json"] = "rbxassetid://10723364435",
		["lucide-file-json-2"] = "rbxassetid://10723364361",
		["lucide-file-key"] = "rbxassetid://10723364605",
		["lucide-file-key-2"] = "rbxassetid://10723364515",
		["lucide-file-line-chart"] = "rbxassetid://10723364725",
		["lucide-file-lock"] = "rbxassetid://10723364957",
		["lucide-file-lock-2"] = "rbxassetid://10723364861",
		["lucide-file-minus"] = "rbxassetid://10723365254",
		["lucide-file-minus-2"] = "rbxassetid://10723365086",
		["lucide-file-output"] = "rbxassetid://10723365457",
		["lucide-file-pie-chart"] = "rbxassetid://10723365598",
		["lucide-file-plus"] = "rbxassetid://10723365877",
		["lucide-file-plus-2"] = "rbxassetid://10723365766",
		["lucide-file-question"] = "rbxassetid://10723365987",
		["lucide-file-scan"] = "rbxassetid://10723366167",
		["lucide-file-search"] = "rbxassetid://10723366550",
		["lucide-file-search-2"] = "rbxassetid://10723366340",
		["lucide-file-signature"] = "rbxassetid://10723366741",
		["lucide-file-spreadsheet"] = "rbxassetid://10723366962",
		["lucide-file-symlink"] = "rbxassetid://10723367098",
		["lucide-file-terminal"] = "rbxassetid://10723367244",
		["lucide-file-text"] = "rbxassetid://10723367380",
		["lucide-file-type"] = "rbxassetid://10723367606",
		["lucide-file-type-2"] = "rbxassetid://10723367509",
		["lucide-file-up"] = "rbxassetid://10723367734",
		["lucide-file-video"] = "rbxassetid://10723373884",
		["lucide-file-video-2"] = "rbxassetid://10723367834",
		["lucide-file-volume"] = "rbxassetid://10723374172",
		["lucide-file-volume-2"] = "rbxassetid://10723374030",
		["lucide-file-warning"] = "rbxassetid://10723374276",
		["lucide-file-x"] = "rbxassetid://10723374544",
		["lucide-file-x-2"] = "rbxassetid://10723374378",
		["lucide-files"] = "rbxassetid://10723374759",
		["lucide-film"] = "rbxassetid://10723374981",
		["lucide-filter"] = "rbxassetid://10723375128",
		["lucide-fingerprint"] = "rbxassetid://10723375250",
		["lucide-flag"] = "rbxassetid://10723375890",
		["lucide-flag-off"] = "rbxassetid://10723375443",
		["lucide-flag-triangle-left"] = "rbxassetid://10723375608",
		["lucide-flag-triangle-right"] = "rbxassetid://10723375727",
		["lucide-flame"] = "rbxassetid://10723376114",
		["lucide-flashlight"] = "rbxassetid://10723376471",
		["lucide-flashlight-off"] = "rbxassetid://10723376365",
		["lucide-flask-conical"] = "rbxassetid://10734883986",
		["lucide-flask-round"] = "rbxassetid://10723376614",
		["lucide-flip-horizontal"] = "rbxassetid://10723376884",
		["lucide-flip-horizontal-2"] = "rbxassetid://10723376745",
		["lucide-flip-vertical"] = "rbxassetid://10723377138",
		["lucide-flip-vertical-2"] = "rbxassetid://10723377026",
		["lucide-flower"] = "rbxassetid://10747830374",
		["lucide-flower-2"] = "rbxassetid://10723377305",
		["lucide-focus"] = "rbxassetid://10723377537",
		["lucide-folder"] = "rbxassetid://10723387563",
		["lucide-folder-archive"] = "rbxassetid://10723384478",
		["lucide-folder-check"] = "rbxassetid://10723384605",
		["lucide-folder-clock"] = "rbxassetid://10723384731",
		["lucide-folder-closed"] = "rbxassetid://10723384893",
		["lucide-folder-cog"] = "rbxassetid://10723385213",
		["lucide-folder-cog-2"] = "rbxassetid://10723385036",
		["lucide-folder-down"] = "rbxassetid://10723385338",
		["lucide-folder-edit"] = "rbxassetid://10723385445",
		["lucide-folder-heart"] = "rbxassetid://10723385545",
		["lucide-folder-input"] = "rbxassetid://10723385721",
		["lucide-folder-key"] = "rbxassetid://10723385848",
		["lucide-folder-lock"] = "rbxassetid://10723386005",
		["lucide-folder-minus"] = "rbxassetid://10723386127",
		["lucide-folder-open"] = "rbxassetid://10723386277",
		["lucide-folder-output"] = "rbxassetid://10723386386",
		["lucide-folder-plus"] = "rbxassetid://10723386531",
		["lucide-folder-search"] = "rbxassetid://10723386787",
		["lucide-folder-search-2"] = "rbxassetid://10723386674",
		["lucide-folder-symlink"] = "rbxassetid://10723386930",
		["lucide-folder-tree"] = "rbxassetid://10723387085",
		["lucide-folder-up"] = "rbxassetid://10723387265",
		["lucide-folder-x"] = "rbxassetid://10723387448",
		["lucide-folders"] = "rbxassetid://10723387721",
		["lucide-form-input"] = "rbxassetid://10723387841",
		["lucide-forward"] = "rbxassetid://10723388016",
		["lucide-frame"] = "rbxassetid://10723394389",
		["lucide-framer"] = "rbxassetid://10723394565",
		["lucide-frown"] = "rbxassetid://10723394681",
		["lucide-fuel"] = "rbxassetid://10723394846",
		["lucide-function-square"] = "rbxassetid://10723395041",
		["lucide-gamepad"] = "rbxassetid://10723395457",
		["lucide-gamepad-2"] = "rbxassetid://10723395215",
		["lucide-gauge"] = "rbxassetid://10723395708",
		["lucide-gavel"] = "rbxassetid://10723395896",
		["lucide-gem"] = "rbxassetid://10723396000",
		["lucide-ghost"] = "rbxassetid://10723396107",
		["lucide-gift"] = "rbxassetid://10723396402",
		["lucide-gift-card"] = "rbxassetid://10723396225",
		["lucide-git-branch"] = "rbxassetid://10723396676",
		["lucide-git-branch-plus"] = "rbxassetid://10723396542",
		["lucide-git-commit"] = "rbxassetid://10723396812",
		["lucide-git-compare"] = "rbxassetid://10723396954",
		["lucide-git-fork"] = "rbxassetid://10723397049",
		["lucide-git-merge"] = "rbxassetid://10723397165",
		["lucide-git-pull-request"] = "rbxassetid://10723397431",
		["lucide-git-pull-request-closed"] = "rbxassetid://10723397268",
		["lucide-git-pull-request-draft"] = "rbxassetid://10734884302",
		["lucide-glass"] = "rbxassetid://10723397788",
		["lucide-glass-2"] = "rbxassetid://10723397529",
		["lucide-glass-water"] = "rbxassetid://10723397678",
		["lucide-glasses"] = "rbxassetid://10723397895",
		["lucide-globe"] = "rbxassetid://10723404337",
		["lucide-globe-2"] = "rbxassetid://10723398002",
		["lucide-grab"] = "rbxassetid://10723404472",
		["lucide-graduation-cap"] = "rbxassetid://10723404691",
		["lucide-grape"] = "rbxassetid://10723404822",
		["lucide-grid"] = "rbxassetid://10723404936",
		["lucide-grip-horizontal"] = "rbxassetid://10723405089",
		["lucide-grip-vertical"] = "rbxassetid://10723405236",
		["lucide-hammer"] = "rbxassetid://10723405360",
		["lucide-hand"] = "rbxassetid://10723405649",
		["lucide-hand-metal"] = "rbxassetid://10723405508",
		["lucide-hard-drive"] = "rbxassetid://10723405749",
		["lucide-hard-hat"] = "rbxassetid://10723405859",
		["lucide-hash"] = "rbxassetid://10723405975",
		["lucide-haze"] = "rbxassetid://10723406078",
		["lucide-headphones"] = "rbxassetid://10723406165",
		["lucide-heart"] = "rbxassetid://10723406885",
		["lucide-heart-crack"] = "rbxassetid://10723406299",
		["lucide-heart-handshake"] = "rbxassetid://10723406480",
		["lucide-heart-off"] = "rbxassetid://10723406662",
		["lucide-heart-pulse"] = "rbxassetid://10723406795",
		["lucide-help-circle"] = "rbxassetid://10723406988",
		["lucide-hexagon"] = "rbxassetid://10723407092",
		["lucide-highlighter"] = "rbxassetid://10723407192",
		["lucide-history"] = "rbxassetid://10723407335",
		["lucide-home"] = "rbxassetid://10723407389",
		["lucide-hourglass"] = "rbxassetid://10723407498",
		["lucide-ice-cream"] = "rbxassetid://10723414308",
		["lucide-image"] = "rbxassetid://10723415040",
		["lucide-image-minus"] = "rbxassetid://10723414487",
		["lucide-image-off"] = "rbxassetid://10723414677",
		["lucide-image-plus"] = "rbxassetid://10723414827",
		["lucide-import"] = "rbxassetid://10723415205",
		["lucide-inbox"] = "rbxassetid://10723415335",
		["lucide-indent"] = "rbxassetid://10723415494",
		["lucide-indian-rupee"] = "rbxassetid://10723415642",
		["lucide-infinity"] = "rbxassetid://10723415766",
		["lucide-info"] = "rbxassetid://10723415903",
		["lucide-inspect"] = "rbxassetid://10723416057",
		["lucide-italic"] = "rbxassetid://10723416195",
		["lucide-japanese-yen"] = "rbxassetid://10723416363",
		["lucide-joystick"] = "rbxassetid://10723416527",
		["lucide-key"] = "rbxassetid://10723416652",
		["lucide-keyboard"] = "rbxassetid://10723416765",
		["lucide-lamp"] = "rbxassetid://10723417513",
		["lucide-lamp-ceiling"] = "rbxassetid://10723416922",
		["lucide-lamp-desk"] = "rbxassetid://10723417016",
		["lucide-lamp-floor"] = "rbxassetid://10723417131",
		["lucide-lamp-wall-down"] = "rbxassetid://10723417240",
		["lucide-lamp-wall-up"] = "rbxassetid://10723417356",
		["lucide-landmark"] = "rbxassetid://10723417608",
		["lucide-languages"] = "rbxassetid://10723417703",
		["lucide-laptop"] = "rbxassetid://10723423881",
		["lucide-laptop-2"] = "rbxassetid://10723417797",
		["lucide-lasso"] = "rbxassetid://10723424235",
		["lucide-lasso-select"] = "rbxassetid://10723424058",
		["lucide-laugh"] = "rbxassetid://10723424372",
		["lucide-layers"] = "rbxassetid://10723424505",
		["lucide-layout"] = "rbxassetid://10723425376",
		["lucide-layout-dashboard"] = "rbxassetid://10723424646",
		["lucide-layout-grid"] = "rbxassetid://10723424838",
		["lucide-layout-list"] = "rbxassetid://10723424963",
		["lucide-layout-template"] = "rbxassetid://10723425187",
		["lucide-leaf"] = "rbxassetid://10723425539",
		["lucide-library"] = "rbxassetid://10723425615",
		["lucide-life-buoy"] = "rbxassetid://10723425685",
		["lucide-lightbulb"] = "rbxassetid://10723425852",
		["lucide-lightbulb-off"] = "rbxassetid://10723425762",
		["lucide-line-chart"] = "rbxassetid://10723426393",
		["lucide-link"] = "rbxassetid://10723426722",
		["lucide-link-2"] = "rbxassetid://10723426595",
		["lucide-link-2-off"] = "rbxassetid://10723426513",
		["lucide-list"] = "rbxassetid://10723433811",
		["lucide-list-checks"] = "rbxassetid://10734884548",
		["lucide-list-end"] = "rbxassetid://10723426886",
		["lucide-list-minus"] = "rbxassetid://10723426986",
		["lucide-list-music"] = "rbxassetid://10723427081",
		["lucide-list-ordered"] = "rbxassetid://10723427199",
		["lucide-list-plus"] = "rbxassetid://10723427334",
		["lucide-list-start"] = "rbxassetid://10723427494",
		["lucide-list-video"] = "rbxassetid://10723427619",
		["lucide-list-x"] = "rbxassetid://10723433655",
		["lucide-loader"] = "rbxassetid://10723434070",
		["lucide-loader-2"] = "rbxassetid://10723433935",
		["lucide-locate"] = "rbxassetid://10723434557",
		["lucide-locate-fixed"] = "rbxassetid://10723434236",
		["lucide-locate-off"] = "rbxassetid://10723434379",
		["lucide-lock"] = "rbxassetid://10723434711",
		["lucide-log-in"] = "rbxassetid://10723434830",
		["lucide-log-out"] = "rbxassetid://10723434906",
		["lucide-luggage"] = "rbxassetid://10723434993",
		["lucide-magnet"] = "rbxassetid://10723435069",
		["lucide-mail"] = "rbxassetid://10734885430",
		["lucide-mail-check"] = "rbxassetid://10723435182",
		["lucide-mail-minus"] = "rbxassetid://10723435261",
		["lucide-mail-open"] = "rbxassetid://10723435342",
		["lucide-mail-plus"] = "rbxassetid://10723435443",
		["lucide-mail-question"] = "rbxassetid://10723435515",
		["lucide-mail-search"] = "rbxassetid://10734884739",
		["lucide-mail-warning"] = "rbxassetid://10734885015",
		["lucide-mail-x"] = "rbxassetid://10734885247",
		["lucide-mails"] = "rbxassetid://10734885614",
		["lucide-map"] = "rbxassetid://10734886202",
		["lucide-map-pin"] = "rbxassetid://10734886004",
		["lucide-map-pin-off"] = "rbxassetid://10734885803",
		["lucide-maximize"] = "rbxassetid://10734886735",
		["lucide-maximize-2"] = "rbxassetid://10734886496",
		["lucide-medal"] = "rbxassetid://10734887072",
		["lucide-megaphone"] = "rbxassetid://10734887454",
		["lucide-megaphone-off"] = "rbxassetid://10734887311",
		["lucide-meh"] = "rbxassetid://10734887603",
		["lucide-menu"] = "rbxassetid://10734887784",
		["lucide-message-circle"] = "rbxassetid://10734888000",
		["lucide-message-square"] = "rbxassetid://10734888228",
		["lucide-mic"] = "rbxassetid://10734888864",
		["lucide-mic-2"] = "rbxassetid://10734888430",
		["lucide-mic-off"] = "rbxassetid://10734888646",
		["lucide-microscope"] = "rbxassetid://10734889106",
		["lucide-microwave"] = "rbxassetid://10734895076",
		["lucide-milestone"] = "rbxassetid://10734895310",
		["lucide-minimize"] = "rbxassetid://10734895698",
		["lucide-minimize-2"] = "rbxassetid://10734895530",
		["lucide-minus"] = "rbxassetid://10734896206",
		["lucide-minus-circle"] = "rbxassetid://10734895856",
		["lucide-minus-square"] = "rbxassetid://10734896029",
		["lucide-monitor"] = "rbxassetid://10734896881",
		["lucide-monitor-off"] = "rbxassetid://10734896360",
		["lucide-monitor-speaker"] = "rbxassetid://10734896512",
		["lucide-moon"] = "rbxassetid://10734897102",
		["lucide-more-horizontal"] = "rbxassetid://10734897250",
		["lucide-more-vertical"] = "rbxassetid://10734897387",
		["lucide-mountain"] = "rbxassetid://10734897956",
		["lucide-mountain-snow"] = "rbxassetid://10734897665",
		["lucide-mouse"] = "rbxassetid://10734898592",
		["lucide-mouse-pointer"] = "rbxassetid://10734898476",
		["lucide-mouse-pointer-2"] = "rbxassetid://10734898194",
		["lucide-mouse-pointer-click"] = "rbxassetid://10734898355",
		["lucide-move"] = "rbxassetid://10734900011",
		["lucide-move-3d"] = "rbxassetid://10734898756",
		["lucide-move-diagonal"] = "rbxassetid://10734899164",
		["lucide-move-diagonal-2"] = "rbxassetid://10734898934",
		["lucide-move-horizontal"] = "rbxassetid://10734899414",
		["lucide-move-vertical"] = "rbxassetid://10734899821",
		["lucide-music"] = "rbxassetid://10734905958",
		["lucide-music-2"] = "rbxassetid://10734900215",
		["lucide-music-3"] = "rbxassetid://10734905665",
		["lucide-music-4"] = "rbxassetid://10734905823",
		["lucide-navigation"] = "rbxassetid://10734906744",
		["lucide-navigation-2"] = "rbxassetid://10734906332",
		["lucide-navigation-2-off"] = "rbxassetid://10734906144",
		["lucide-navigation-off"] = "rbxassetid://10734906580",
		["lucide-network"] = "rbxassetid://10734906975",
		["lucide-newspaper"] = "rbxassetid://10734907168",
		["lucide-octagon"] = "rbxassetid://10734907361",
		["lucide-option"] = "rbxassetid://10734907649",
		["lucide-outdent"] = "rbxassetid://10734907933",
		["lucide-package"] = "rbxassetid://10734909540",
		["lucide-package-2"] = "rbxassetid://10734908151",
		["lucide-package-check"] = "rbxassetid://10734908384",
		["lucide-package-minus"] = "rbxassetid://10734908626",
		["lucide-package-open"] = "rbxassetid://10734908793",
		["lucide-package-plus"] = "rbxassetid://10734909016",
		["lucide-package-search"] = "rbxassetid://10734909196",
		["lucide-package-x"] = "rbxassetid://10734909375",
		["lucide-paint-bucket"] = "rbxassetid://10734909847",
		["lucide-paintbrush"] = "rbxassetid://10734910187",
		["lucide-paintbrush-2"] = "rbxassetid://10734910030",
		["lucide-palette"] = "rbxassetid://10734910430",
		["lucide-palmtree"] = "rbxassetid://10734910680",
		["lucide-paperclip"] = "rbxassetid://10734910927",
		["lucide-party-popper"] = "rbxassetid://10734918735",
		["lucide-pause"] = "rbxassetid://10734919336",
		["lucide-pause-circle"] = "rbxassetid://10735024209",
		["lucide-pause-octagon"] = "rbxassetid://10734919143",
		["lucide-pen-tool"] = "rbxassetid://10734919503",
		["lucide-pencil"] = "rbxassetid://10734919691",
		["lucide-percent"] = "rbxassetid://10734919919",
		["lucide-person-standing"] = "rbxassetid://10734920149",
		["lucide-phone"] = "rbxassetid://10734921524",
		["lucide-phone-call"] = "rbxassetid://10734920305",
		["lucide-phone-forwarded"] = "rbxassetid://10734920508",
		["lucide-phone-incoming"] = "rbxassetid://10734920694",
		["lucide-phone-missed"] = "rbxassetid://10734920845",
		["lucide-phone-off"] = "rbxassetid://10734921077",
		["lucide-phone-outgoing"] = "rbxassetid://10734921288",
		["lucide-pie-chart"] = "rbxassetid://10734921727",
		["lucide-piggy-bank"] = "rbxassetid://10734921935",
		["lucide-pin"] = "rbxassetid://10734922324",
		["lucide-pin-off"] = "rbxassetid://10734922180",
		["lucide-pipette"] = "rbxassetid://10734922497",
		["lucide-pizza"] = "rbxassetid://10734922774",
		["lucide-plane"] = "rbxassetid://10734922971",
		["lucide-play"] = "rbxassetid://10734923549",
		["lucide-play-circle"] = "rbxassetid://10734923214",
		["lucide-plus"] = "rbxassetid://10734924532",
		["lucide-plus-circle"] = "rbxassetid://10734923868",
		["lucide-plus-square"] = "rbxassetid://10734924219",
		["lucide-podcast"] = "rbxassetid://10734929553",
		["lucide-pointer"] = "rbxassetid://10734929723",
		["lucide-pound-sterling"] = "rbxassetid://10734929981",
		["lucide-power"] = "rbxassetid://10734930466",
		["lucide-power-off"] = "rbxassetid://10734930257",
		["lucide-printer"] = "rbxassetid://10734930632",
		["lucide-puzzle"] = "rbxassetid://10734930886",
		["lucide-quote"] = "rbxassetid://10734931234",
		["lucide-radio"] = "rbxassetid://10734931596",
		["lucide-radio-receiver"] = "rbxassetid://10734931402",
		["lucide-rectangle-horizontal"] = "rbxassetid://10734931777",
		["lucide-rectangle-vertical"] = "rbxassetid://10734932081",
		["lucide-recycle"] = "rbxassetid://10734932295",
		["lucide-redo"] = "rbxassetid://10734932822",
		["lucide-redo-2"] = "rbxassetid://10734932586",
		["lucide-refresh-ccw"] = "rbxassetid://10734933056",
		["lucide-refresh-cw"] = "rbxassetid://10734933222",
		["lucide-refrigerator"] = "rbxassetid://10734933465",
		["lucide-regex"] = "rbxassetid://10734933655",
		["lucide-repeat"] = "rbxassetid://10734933966",
		["lucide-repeat-1"] = "rbxassetid://10734933826",
		["lucide-reply"] = "rbxassetid://10734934252",
		["lucide-reply-all"] = "rbxassetid://10734934132",
		["lucide-rewind"] = "rbxassetid://10734934347",
		["lucide-rocket"] = "rbxassetid://10734934585",
		["lucide-rocking-chair"] = "rbxassetid://10734939942",
		["lucide-rotate-3d"] = "rbxassetid://10734940107",
		["lucide-rotate-ccw"] = "rbxassetid://10734940376",
		["lucide-rotate-cw"] = "rbxassetid://10734940654",
		["lucide-rss"] = "rbxassetid://10734940825",
		["lucide-ruler"] = "rbxassetid://10734941018",
		["lucide-russian-ruble"] = "rbxassetid://10734941199",
		["lucide-sailboat"] = "rbxassetid://10734941354",
		["lucide-save"] = "rbxassetid://10734941499",
		["lucide-scale"] = "rbxassetid://10734941912",
		["lucide-scale-3d"] = "rbxassetid://10734941739",
		["lucide-scaling"] = "rbxassetid://10734942072",
		["lucide-scan"] = "rbxassetid://10734942565",
		["lucide-scan-face"] = "rbxassetid://10734942198",
		["lucide-scan-line"] = "rbxassetid://10734942351",
		["lucide-scissors"] = "rbxassetid://10734942778",
		["lucide-screen-share"] = "rbxassetid://10734943193",
		["lucide-screen-share-off"] = "rbxassetid://10734942967",
		["lucide-scroll"] = "rbxassetid://10734943448",
		["lucide-search"] = "rbxassetid://10734943674",
		["lucide-send"] = "rbxassetid://10734943902",
		["lucide-separator-horizontal"] = "rbxassetid://10734944115",
		["lucide-separator-vertical"] = "rbxassetid://10734944326",
		["lucide-server"] = "rbxassetid://10734949856",
		["lucide-server-cog"] = "rbxassetid://10734944444",
		["lucide-server-crash"] = "rbxassetid://10734944554",
		["lucide-server-off"] = "rbxassetid://10734944668",
		["lucide-settings"] = "rbxassetid://10734950309",
		["lucide-settings-2"] = "rbxassetid://10734950020",
		["lucide-share"] = "rbxassetid://10734950813",
		["lucide-share-2"] = "rbxassetid://10734950553",
		["lucide-sheet"] = "rbxassetid://10734951038",
		["lucide-shield"] = "rbxassetid://10734951847",
		["lucide-shield-alert"] = "rbxassetid://10734951173",
		["lucide-shield-check"] = "rbxassetid://10734951367",
		["lucide-shield-close"] = "rbxassetid://10734951535",
		["lucide-shield-off"] = "rbxassetid://10734951684",
		["lucide-shirt"] = "rbxassetid://10734952036",
		["lucide-shopping-bag"] = "rbxassetid://10734952273",
		["lucide-shopping-cart"] = "rbxassetid://10734952479",
		["lucide-shovel"] = "rbxassetid://10734952773",
		["lucide-shower-head"] = "rbxassetid://10734952942",
		["lucide-shrink"] = "rbxassetid://10734953073",
		["lucide-shrub"] = "rbxassetid://10734953241",
		["lucide-shuffle"] = "rbxassetid://10734953451",
		["lucide-sidebar"] = "rbxassetid://10734954301",
		["lucide-sidebar-close"] = "rbxassetid://10734953715",
		["lucide-sidebar-open"] = "rbxassetid://10734954000",
		["lucide-sigma"] = "rbxassetid://10734954538",
		["lucide-signal"] = "rbxassetid://10734961133",
		["lucide-signal-high"] = "rbxassetid://10734954807",
		["lucide-signal-low"] = "rbxassetid://10734955080",
		["lucide-signal-medium"] = "rbxassetid://10734955336",
		["lucide-signal-zero"] = "rbxassetid://10734960878",
		["lucide-siren"] = "rbxassetid://10734961284",
		["lucide-skip-back"] = "rbxassetid://10734961526",
		["lucide-skip-forward"] = "rbxassetid://10734961809",
		["lucide-skull"] = "rbxassetid://10734962068",
		["lucide-slack"] = "rbxassetid://10734962339",
		["lucide-slash"] = "rbxassetid://10734962600",
		["lucide-slice"] = "rbxassetid://10734963024",
		["lucide-sliders"] = "rbxassetid://10734963400",
		["lucide-sliders-horizontal"] = "rbxassetid://10734963191",
		["lucide-smartphone"] = "rbxassetid://10734963940",
		["lucide-smartphone-charging"] = "rbxassetid://10734963671",
		["lucide-smile"] = "rbxassetid://10734964441",
		["lucide-smile-plus"] = "rbxassetid://10734964188",
		["lucide-snowflake"] = "rbxassetid://10734964600",
		["lucide-sofa"] = "rbxassetid://10734964852",
		["lucide-sort-asc"] = "rbxassetid://10734965115",
		["lucide-sort-desc"] = "rbxassetid://10734965287",
		["lucide-speaker"] = "rbxassetid://10734965419",
		["lucide-sprout"] = "rbxassetid://10734965572",
		["lucide-square"] = "rbxassetid://10734965702",
		["lucide-star"] = "rbxassetid://10734966248",
		["lucide-star-half"] = "rbxassetid://10734965897",
		["lucide-star-off"] = "rbxassetid://10734966097",
		["lucide-stethoscope"] = "rbxassetid://10734966384",
		["lucide-sticker"] = "rbxassetid://10734972234",
		["lucide-sticky-note"] = "rbxassetid://10734972463",
		["lucide-stop-circle"] = "rbxassetid://10734972621",
		["lucide-stretch-horizontal"] = "rbxassetid://10734972862",
		["lucide-stretch-vertical"] = "rbxassetid://10734973130",
		["lucide-strikethrough"] = "rbxassetid://10734973290",
		["lucide-subscript"] = "rbxassetid://10734973457",
		["lucide-sun"] = "rbxassetid://10734974297",
		["lucide-sun-dim"] = "rbxassetid://10734973645",
		["lucide-sun-medium"] = "rbxassetid://10734973778",
		["lucide-sun-moon"] = "rbxassetid://10734973999",
		["lucide-sun-snow"] = "rbxassetid://10734974130",
		["lucide-sunrise"] = "rbxassetid://10734974522",
		["lucide-sunset"] = "rbxassetid://10734974689",
		["lucide-superscript"] = "rbxassetid://10734974850",
		["lucide-swiss-franc"] = "rbxassetid://10734975024",
		["lucide-switch-camera"] = "rbxassetid://10734975214",
		["lucide-sword"] = "rbxassetid://10734975486",
		["lucide-swords"] = "rbxassetid://10734975692",
		["lucide-syringe"] = "rbxassetid://10734975932",
		["lucide-table"] = "rbxassetid://10734976230",
		["lucide-table-2"] = "rbxassetid://10734976097",
		["lucide-tablet"] = "rbxassetid://10734976394",
		["lucide-tag"] = "rbxassetid://10734976528",
		["lucide-tags"] = "rbxassetid://10734976739",
		["lucide-target"] = "rbxassetid://10734977012",
		["lucide-tent"] = "rbxassetid://10734981750",
		["lucide-terminal"] = "rbxassetid://10734982144",
		["lucide-terminal-square"] = "rbxassetid://10734981995",
		["lucide-text-cursor"] = "rbxassetid://10734982395",
		["lucide-text-cursor-input"] = "rbxassetid://10734982297",
		["lucide-thermometer"] = "rbxassetid://10734983134",
		["lucide-thermometer-snowflake"] = "rbxassetid://10734982571",
		["lucide-thermometer-sun"] = "rbxassetid://10734982771",
		["lucide-thumbs-down"] = "rbxassetid://10734983359",
		["lucide-thumbs-up"] = "rbxassetid://10734983629",
		["lucide-ticket"] = "rbxassetid://10734983868",
		["lucide-timer"] = "rbxassetid://10734984606",
		["lucide-timer-off"] = "rbxassetid://10734984138",
		["lucide-timer-reset"] = "rbxassetid://10734984355",
		["lucide-toggle-left"] = "rbxassetid://10734984834",
		["lucide-toggle-right"] = "rbxassetid://10734985040",
		["lucide-tornado"] = "rbxassetid://10734985247",
		["lucide-toy-brick"] = "rbxassetid://10747361919",
		["lucide-train"] = "rbxassetid://10747362105",
		["lucide-trash"] = "rbxassetid://10747362393",
		["lucide-trash-2"] = "rbxassetid://10747362241",
		["lucide-tree-deciduous"] = "rbxassetid://10747362534",
		["lucide-tree-pine"] = "rbxassetid://10747362748",
		["lucide-trees"] = "rbxassetid://10747363016",
		["lucide-trending-down"] = "rbxassetid://10747363205",
		["lucide-trending-up"] = "rbxassetid://10747363465",
		["lucide-triangle"] = "rbxassetid://10747363621",
		["lucide-trophy"] = "rbxassetid://10747363809",
		["lucide-truck"] = "rbxassetid://10747364031",
		["lucide-tv"] = "rbxassetid://10747364593",
		["lucide-tv-2"] = "rbxassetid://10747364302",
		["lucide-type"] = "rbxassetid://10747364761",
		["lucide-umbrella"] = "rbxassetid://10747364971",
		["lucide-underline"] = "rbxassetid://10747365191",
		["lucide-undo"] = "rbxassetid://10747365484",
		["lucide-undo-2"] = "rbxassetid://10747365359",
		["lucide-unlink"] = "rbxassetid://10747365771",
		["lucide-unlink-2"] = "rbxassetid://10747397871",
		["lucide-unlock"] = "rbxassetid://10747366027",
		["lucide-upload"] = "rbxassetid://10747366434",
		["lucide-upload-cloud"] = "rbxassetid://10747366266",
		["lucide-usb"] = "rbxassetid://10747366606",
		["lucide-user"] = "rbxassetid://10747373176",
		["lucide-user-check"] = "rbxassetid://10747371901",
		["lucide-user-cog"] = "rbxassetid://10747372167",
		["lucide-user-minus"] = "rbxassetid://10747372346",
		["lucide-user-plus"] = "rbxassetid://10747372702",
		["lucide-user-x"] = "rbxassetid://10747372992",
		["lucide-users"] = "rbxassetid://10747373426",
		["lucide-utensils"] = "rbxassetid://10747373821",
		["lucide-utensils-crossed"] = "rbxassetid://10747373629",
		["lucide-venetian-mask"] = "rbxassetid://10747374003",
		["lucide-verified"] = "rbxassetid://10747374131",
		["lucide-vibrate"] = "rbxassetid://10747374489",
		["lucide-vibrate-off"] = "rbxassetid://10747374269",
		["lucide-video"] = "rbxassetid://10747374938",
		["lucide-video-off"] = "rbxassetid://10747374721",
		["lucide-view"] = "rbxassetid://10747375132",
		["lucide-voicemail"] = "rbxassetid://10747375281",
		["lucide-volume"] = "rbxassetid://10747376008",
		["lucide-volume-1"] = "rbxassetid://10747375450",
		["lucide-volume-2"] = "rbxassetid://10747375679",
		["lucide-volume-x"] = "rbxassetid://10747375880",
		["lucide-wallet"] = "rbxassetid://10747376205",
		["lucide-wand"] = "rbxassetid://10747376565",
		["lucide-wand-2"] = "rbxassetid://10747376349",
		["lucide-watch"] = "rbxassetid://10747376722",
		["lucide-waves"] = "rbxassetid://10747376931",
		["lucide-webcam"] = "rbxassetid://10747381992",
		["lucide-wifi"] = "rbxassetid://10747382504",
		["lucide-wifi-off"] = "rbxassetid://10747382268",
		["lucide-wind"] = "rbxassetid://10747382750",
		["lucide-wrap-text"] = "rbxassetid://10747383065",
		["lucide-wrench"] = "rbxassetid://10747383470",
		["lucide-x"] = "rbxassetid://10747384394",
		["lucide-x-circle"] = "rbxassetid://10747383819",
		["lucide-x-octagon"] = "rbxassetid://10747384037",
		["lucide-x-square"] = "rbxassetid://10747384217",
		["lucide-zoom-in"] = "rbxassetid://10747384552",
		["lucide-zoom-out"] = "rbxassetid://10747384679",
	},
};



-- File Manager --
do

	local SetBlock = function(element , type , value)
		if type == "Keybind" then
			element:SetValue(value);
		elseif type == "Toggle" then
			element:SetValue(value);
		elseif type == "Dropdown" then
			element:SetDefault(value);
		elseif type == "Slider" then
			element:SetValue(value);
		elseif type == "TextBox" then
			element:SetValue(value);
		elseif type == "ColorPicker" then
			element:SetValue(Color3.fromRGB(value[1],value[2],value[3]));
		end;
	end;

	local ParserObject = function(model, cfg)
		for i,v in next , cfg do
			local element = model:GetElementFromKey(i);

			local Type = string.split(i,'_')[1];

			if element.Type == Type then
				SetBlock(element.API,element.Type,v.Value)
			else
				warn("Type mismatch:","["..element.Type.."]","["..Type.."]")
			end;
		end;
	end;

	local Parser = function(config , window,VERSION : string)
		local WinCFG = window:GetConfigs();

		if WinCFG.VERSION ~= VERSION then
			warn("VERSION mismatch [Window: "..tostring(WinCFG.VERSION)..", File: "..tostring(VERSION).."]");
			return false , "VERSION mismatch [Window: "..tostring(WinCFG.VERSION)..", File: "..tostring(VERSION).."]";
		end;

		for Tab,Value in next , config do
			local WindowTab : Tab = window:GetTabFromKey(tostring(Tab));

			if WindowTab then
				local Left = Value.Left;
				local Right = Value.Right;
				local Sections = Value.Sections;

				ParserObject(WindowTab.Left,Left);

				ParserObject(WindowTab.Right,Right);

				for i,v in next , Sections do
					local Section = WindowTab:GetSectionFromKey(i);

					if Section then
						ParserObject(Section,v);
					else
						warn('Section not found +1',i)
					end;
				end;
			else
				warn('Tab not found +1');
			end;
		end;

		return true;
	end;

	function Airflow.FileManager:WriteConfig(Window,path : string)
		local config = Window:GetConfigs();
		local mem = game:GetService('HttpService'):JSONEncode(config);

		if writefile then
			writefile(path,mem);
		end;

		return mem;
	end;

	function Airflow.FileManager:GetConfig(Window)
		local config = Window:GetConfigs();
		local mem = game:GetService('HttpService'):JSONEncode(config);

		return mem;
	end;

	function Airflow.FileManager:LoadConfig(Window,path : string,VERSION : string)
		local content = readfile(path);
		local Code = game:GetService('HttpService'):JSONDecode(content);

		return Parser(Code,Window,VERSION or "1.0");
	end;

	function Airflow.FileManager:LoadConfigFromString(Window,str : string,VERSION : string)
		local Code = game:GetService('HttpService'):JSONDecode(str);

		return Parser(Code,Window,VERSION or "1.0");
	end;

	function Airflow.FileManager:GetVersion(path : string)
		local Code = game:GetService('HttpService'):JSONDecode(readfile(path));

		if Code.VERSION then
			return Code.VERSION;
		end;
	end;
end;

function Airflow:LoadAssets() : nil
	for i,v in next , Airflow.Lucide do
		game:GetService('ContentProvider'):Preload(v);
	end;
end;

function Airflow:IsMobile() : boolean
	return UserInputService.TouchEnabled;	
end;

function Airflow:RandomString() : string
	return string.char(math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102),math.random(64,102));	
end;

function Airflow:IsMouseOverFrame(Frame) : boolean
	local AbsPos, AbsSize = Frame.AbsolutePosition, Frame.AbsoluteSize;

	if Mouse.X >= AbsPos.X and Mouse.X <= AbsPos.X + AbsSize.X and Mouse.Y >= AbsPos.Y and Mouse.Y <= AbsPos.Y + AbsSize.Y then
		return true;
	end;
end;

function Airflow:GetCalculatePosition(planePos: number, planeNormal: number, rayOrigin: number, rayDirection: number) : number
	local n = planeNormal;
	local d = rayDirection;
	local v = rayOrigin - planePos;

	local num = (n.x * v.x) + (n.y * v.y) + (n.z * v.z);
	local den = (n.x * d.x) + (n.y * d.y) + (n.z * d.z);
	local a = -num / den;

	return rayOrigin + (a * rayDirection);
end;

function Airflow:Blur(element : Frame) : RBXScriptSignal
	local Part = Instance.new('Part',workspace.Camera);
	local DepthOfField = Instance.new('DepthOfFieldEffect',cloneref(game:GetService('Lighting')));
	local BlockMesh = Instance.new("BlockMesh");
	local userSettings = UserSettings():GetService("UserGameSettings");

	BlockMesh.Parent = Part;

	Part.Material = Enum.Material.Glass;
	Part.Transparency = 1;
	Part.Reflectance = 1;
	Part.CastShadow = false;
	Part.Anchored = true;
	Part.CanCollide = false;
	Part.CanQuery = false;
	Part.CollisionGroup = Airflow:RandomString();
	Part.Size = Vector3.new(1, 1, 1) * 0.01;
	Part.Color = Color3.fromRGB(0,0,0);

	DepthOfField.Enabled = true;
	DepthOfField.FarIntensity = 0;
	DepthOfField.FocusDistance = 0;
	DepthOfField.InFocusRadius = 1000;
	DepthOfField.NearIntensity = 1;
	DepthOfField.Name = Airflow:RandomString();

	Part.Name = Airflow:RandomString();
	
	local rbxsignal = RunService.RenderStepped:Connect(function()
		if element.BackgroundTransparency < 0.7 then
			Airflow:CreateAnimation(DepthOfField,0.1,nil,{
				NearIntensity = 1
			})

			Airflow:CreateAnimation(Part,0.1,nil,{
				Transparency = 0.97,
			})

			Airflow:CreateAnimation(Part,0.3,nil,{
				Size = Vector3.new(1, 1, 1) * 0.01;
			})
		else
			Airflow:CreateAnimation(DepthOfField,0.1,nil,{
				NearIntensity = 0
			})

			Airflow:CreateAnimation(Part,0.3,nil,{
				Size = Vector3.zero;
			})

			Airflow:CreateAnimation(Part,0.1,nil,{
				Transparency = 1.5,
			})
		end;

		if element.BackgroundTransparency <= 0.95 then
			local corner0 = element.AbsolutePosition;
			local corner1 = corner0 + element.AbsoluteSize;

			local ray0 = CurrentCamera.ScreenPointToRay(CurrentCamera,corner0.X, corner0.Y, 1);
			local ray1 = CurrentCamera.ScreenPointToRay(CurrentCamera,corner1.X, corner1.Y, 1);

			local planeOrigin = CurrentCamera.CFrame.Position + CurrentCamera.CFrame.LookVector * (0.05 - CurrentCamera.NearPlaneZ);

			local planeNormal = CurrentCamera.CFrame.LookVector;

			local pos0 = Airflow:GetCalculatePosition(planeOrigin, planeNormal, ray0.Origin, ray0.Direction);
			local pos1 = Airflow:GetCalculatePosition(planeOrigin, planeNormal, ray1.Origin, ray1.Direction);

			pos0 = CurrentCamera.CFrame:PointToObjectSpace(pos0);
			pos1 = CurrentCamera.CFrame:PointToObjectSpace(pos1);

			local size   = pos1 - pos0;
			local center = (pos0 + pos1) / 2;

			BlockMesh.Offset = center
			BlockMesh.Scale  = size / 0.0101;
			Part.CFrame = CurrentCamera.CFrame;
		end;
	end);
	
	element.Destroying:Connect(function()
		rbxsignal:Disconnect();
		Part:Destroy();
		DepthOfField:Destroy();
	end);
	
	return rbxsignal;
end;

function Airflow:GetIcon(name : string) : string
	return Airflow.Lucide['lucide-'..tostring(name)] or Airflow.Lucide[name] or Airflow.Lucide[tostring(name)] or "";
end;

function Airflow:SetIcon(name : string, value : string) : nil
	Airflow.Lucide[name] = value;
end;

function Airflow:Rounding(num, numDecimalPlaces) : number
	local mult = 10 ^ (numDecimalPlaces or 0);
	return math.floor(num * mult + 0.5) / mult;
end;

function Airflow:CreateAnimation(Instance: Instance , Time: number , Style : Enum.EasingStyle , Property : {[string] : any}) : Tween
	local Tween = TweenService:Create(Instance,TweenInfo.new(Time or 1 , Style or Enum.EasingStyle.Quint),Property);

	Tween:Play();

	return Tween;
end;

function Airflow:NewInput(frame : Frame , Callback : () -> ()) : TextButton
	local Button = Instance.new('TextButton',frame);

	Button.ZIndex = frame.ZIndex + 10;
	Button.Size = UDim2.fromScale(1,1);
	Button.BackgroundTransparency = 1;
	Button.TextTransparency = 1;

	if Callback then
		Button.MouseButton1Click:Connect(Callback);
	end;

	return Button;
end;

function Airflow:Hover(element : Frame)
	local Original = Color3.fromRGB(91, 91, 91);
	local Hover = Color3.fromRGB(144, 144, 144);

	element.MouseEnter:Connect(function()
		Airflow:CreateAnimation(element,0.35,nil,{
			BackgroundColor3 = Hover
		})
	end)

	element.MouseLeave:Connect(function()
		Airflow:CreateAnimation(element,0.35,nil,{
			BackgroundColor3 = Original
		})
	end)
end;

-- Color Picker --
do
	local ColorPicker = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local UIStroke = Instance.new("UIStroke")
	local ColorPick = Instance.new("ImageLabel")
	local UICorner_2 = Instance.new("UICorner")
	local mouse = Instance.new("ImageLabel")
	local ColorSelect = Instance.new("Frame")
	local UIGradient = Instance.new("UIGradient")
	local UICorner_3 = Instance.new("UICorner")
	local move = Instance.new("Frame")
	local left = Instance.new("Frame")
	local right = Instance.new("Frame")
	local Copy = Instance.new("Frame")
	local UICorner_4 = Instance.new("UICorner")
	local Text = Instance.new("TextLabel")
	local Paste = Instance.new("Frame")
	local UICorner_5 = Instance.new("UICorner")
	local Text_2 = Instance.new("TextLabel")

	ColorPicker.Name = Airflow:RandomString()
	ColorPicker.Parent = Airflow.ScreenGui;
	ColorPicker.AnchorPoint = Vector2.new(0.5, 0.5)
	ColorPicker.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
	ColorPicker.BackgroundTransparency = 0.89
	ColorPicker.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ColorPicker.BorderSizePixel = 0
	ColorPicker.ClipsDescendants = true
	ColorPicker.Position = UDim2.new(0.845068753, 0, 0.606334031, 0)
	ColorPicker.Size = UDim2.new(0.100000001, 100, 0.100000001, 100)
	ColorPicker.SizeConstraint = Enum.SizeConstraint.RelativeYY
	ColorPicker.ZIndex = 105;
	ColorPicker.Visible = false;
	ColorPicker.Active = true;

	ColorPicker:GetPropertyChangedSignal('BackgroundTransparency'):Connect(function()
		if ColorPicker.BackgroundTransparency <= 0.9 then
			ColorPicker.Visible = true;
		else
			ColorPicker.Visible = false;
		end;
	end)

	Airflow.Features.ColorPickerRoot = ColorPicker;

	UICorner.CornerRadius = UDim.new(0, 5)
	UICorner.Parent = ColorPicker

	UIStroke.Transparency = 1
	UIStroke.Color = Color3.fromRGB(83, 83, 83)
	UIStroke.Parent = ColorPicker

	ColorPick.Name = Airflow:RandomString()
	ColorPick.Parent = ColorPicker
	ColorPick.BackgroundColor3 = Color3.fromRGB(255, 0, 4)
	ColorPick.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ColorPick.BorderSizePixel = 0
	ColorPick.Position = UDim2.new(0, 10, 0, 10)
	ColorPick.Size = UDim2.new(0.75, 0, 0.75, 0)
	ColorPick.ZIndex = 107
	ColorPick.Image = "rbxassetid://4155801252"
	ColorPick.ImageTransparency = 1;
	ColorPick.BackgroundTransparency = 1;

	UICorner_2.CornerRadius = UDim.new(0, 3)
	UICorner_2.Parent = ColorPick

	mouse.Name = Airflow:RandomString()
	mouse.Parent = ColorPick
	mouse.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	mouse.BackgroundTransparency = 1.000
	mouse.BorderColor3 = Color3.fromRGB(0, 0, 0)
	mouse.BorderSizePixel = 0
	mouse.Position = UDim2.new(0, 15, 0, 15)
	mouse.Size = UDim2.new(0, 15, 0, 15)
	mouse.ZIndex = 107
	mouse.Image = "http://www.roblox.com/asset/?id=4805639000"
	mouse.ImageTransparency = 1;
	mouse.AnchorPoint = Vector2.new(0.5,0.5);

	ColorSelect.Name = Airflow:RandomString()
	ColorSelect.Parent = ColorPicker
	ColorSelect.AnchorPoint = Vector2.new(1, 0)
	ColorSelect.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ColorSelect.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ColorSelect.BorderSizePixel = 0
	ColorSelect.Position = UDim2.new(1, -10, 0, 10)
	ColorSelect.Size = UDim2.new(0.100000001, -3, 0.75, 0)
	ColorSelect.SizeConstraint = Enum.SizeConstraint.RelativeYY
	ColorSelect.ZIndex = 107
	ColorSelect.BackgroundTransparency = 1;

	UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(255, 0, 0)), ColorSequenceKeypoint.new(0.10, Color3.fromRGB(255, 153, 0)), ColorSequenceKeypoint.new(0.20, Color3.fromRGB(203, 255, 0)), ColorSequenceKeypoint.new(0.30, Color3.fromRGB(50, 255, 0)), ColorSequenceKeypoint.new(0.40, Color3.fromRGB(0, 255, 102)), ColorSequenceKeypoint.new(0.50, Color3.fromRGB(0, 255, 255)), ColorSequenceKeypoint.new(0.60, Color3.fromRGB(0, 101, 255)), ColorSequenceKeypoint.new(0.70, Color3.fromRGB(50, 0, 255)), ColorSequenceKeypoint.new(0.80, Color3.fromRGB(204, 0, 255)), ColorSequenceKeypoint.new(0.90, Color3.fromRGB(255, 0, 153)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 0, 0))}
	UIGradient.Rotation = 90
	UIGradient.Parent = ColorSelect

	UICorner_3.CornerRadius = UDim.new(0, 3)
	UICorner_3.Parent = ColorSelect

	move.Name = Airflow:RandomString()
	move.Parent = ColorSelect
	move.AnchorPoint = Vector2.new(0.5, 0)
	move.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	move.BackgroundTransparency = 1.000
	move.BorderColor3 = Color3.fromRGB(0, 0, 0)
	move.BorderSizePixel = 0
	move.Position = UDim2.new(0.5, 0, 0, 15)
	move.Size = UDim2.new(1, 8, 0, 2)
	move.ZIndex = 108

	left.Name = Airflow:RandomString()
	left.Parent = move
	left.AnchorPoint = Vector2.new(0, 0.5)
	left.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	left.BorderColor3 = Color3.fromRGB(0, 0, 0)
	left.BorderSizePixel = 0
	left.Position = UDim2.new(0, 0, 0.5, 0)
	left.Size = UDim2.new(0, 7, 1, 0)
	left.ZIndex = 109
	left.BackgroundTransparency = 1;

	right.Name = Airflow:RandomString()
	right.Parent = move
	right.AnchorPoint = Vector2.new(1, 0.5)
	right.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	right.BorderColor3 = Color3.fromRGB(0, 0, 0)
	right.BorderSizePixel = 0
	right.Position = UDim2.new(1, 0, 0.5, 0)
	right.Size = UDim2.new(0, 7, 1, 0)
	right.ZIndex = 109
	right.BackgroundTransparency = 1

	Copy.Name = Airflow:RandomString()
	Copy.Parent = ColorPicker
	Copy.AnchorPoint = Vector2.new(0, 1)
	Copy.BackgroundColor3 = Color3.fromRGB(91, 91, 91)
	Copy.BackgroundTransparency = 0.800
	Copy.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Copy.BorderSizePixel = 0
	Copy.ClipsDescendants = true
	Copy.Position = UDim2.new(0, 10, 1, -5)
	Copy.Size = UDim2.new(0.5, -12, 0, 22)
	Copy.ZIndex = 300

	UICorner_4.CornerRadius = UDim.new(0, 4)
	UICorner_4.Parent = Copy

	Text.Name = Airflow:RandomString()
	Text.Parent = Copy
	Text.AnchorPoint = Vector2.new(0.5, 0.5)
	Text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Text.BackgroundTransparency = 1.000
	Text.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Text.BorderSizePixel = 0
	Text.Position = UDim2.new(0.5, 0, 0.5, 0)
	Text.Size = UDim2.new(1, -20, 0, 20)
	Text.ZIndex = 300
	Text.Font = Enum.Font.GothamMedium
	Text.Text = "Copy"
	Text.TextColor3 = Color3.fromRGB(255, 255, 255)
	Text.TextSize = 14.000
	Text.TextWrapped = true
	Text.TextTransparency = 1;

	Paste.Name = Airflow:RandomString()
	Paste.Parent = ColorPicker
	Paste.AnchorPoint = Vector2.new(1, 1)
	Paste.BackgroundColor3 = Color3.fromRGB(91, 91, 91)
	Paste.BackgroundTransparency = 0.800
	Paste.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Paste.BorderSizePixel = 0
	Paste.ClipsDescendants = true
	Paste.Position = UDim2.new(1, -10, 1, -5)
	Paste.Size = UDim2.new(0.5, -12, 0, 22)
	Paste.ZIndex = 300

	UICorner_5.CornerRadius = UDim.new(0, 4)
	UICorner_5.Parent = Paste

	Text_2.Name = Airflow:RandomString()
	Text_2.Parent = Paste
	Text_2.AnchorPoint = Vector2.new(0.5, 0.5)
	Text_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Text_2.BackgroundTransparency = 1.000
	Text_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Text_2.BorderSizePixel = 0
	Text_2.Position = UDim2.new(0.5, 0, 0.5, 0)
	Text_2.Size = UDim2.new(1, -20, 0, 20)
	Text_2.ZIndex = 300
	Text_2.Font = Enum.Font.GothamMedium
	Text_2.Text = "Paste"
	Text_2.TextColor3 = Color3.fromRGB(255, 255, 255)
	Text_2.TextSize = 14.000
	Text_2.TextWrapped = true
	Text_2.TextTransparency = 1;

	Airflow.Features.ColorPickerToggle = false;
	Airflow.Features.ColorDefault = Color3.fromRGB(255,255,255);
	Airflow.Features.CopyColor =Airflow.Features.ColorDefault;
	Airflow.Features.Callback = nil;

	Airflow:Hover(Copy);
	Airflow:Hover(Paste);

	Airflow:NewInput(Copy,function()
		Airflow.Features.CopyColor =Airflow.Features.ColorDefault;
	end);

	Airflow:NewInput(Paste,function()
		local H,S,V = Airflow.Features.CopyColor:ToHSV();

		Airflow.Features.ColorDefault = Airflow.Features.CopyColor;

		Airflow:CreateAnimation(ColorPick,0.5,nil,{
			BackgroundColor3 = Color3.fromHSV(H,1,1);
		})

		Airflow:CreateAnimation(mouse,0.5,nil,{
			Position = UDim2.new(S, 0,1 - V, 0)
		})

		Airflow:CreateAnimation(move,0.5,nil,{
			Position = UDim2.new(0.5,0,H,0)
		})

		if Airflow.Features.Callback then
			task.spawn(Airflow.Features.Callback,Airflow.Features.ColorDefault)	
		end;
	end);

	local OldCode = 0;
	local CodeH,CodeV = 1, 1;
	local IsPressM1 = false;

	do
		ColorPicker.InputBegan:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
				IsPressM1 = true;
			end;
		end)

		ColorPicker.InputEnded:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
				IsPressM1 = false;
			end;
		end)

		UserInputService.InputBegan:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
				if not Airflow:IsMouseOverFrame(ColorPicker) then
					Airflow.Features:OnColorPicker(false)
				end;
			end;
		end)

		ColorSelect.InputBegan:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
				IsPressM1 = true;

				while (UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) or IsPressM1) do task.wait()
					local ColorY = ColorSelect.AbsolutePosition.Y
					local ColorYM = ColorY + ColorSelect.AbsoluteSize.Y;
					local Value = math.clamp(Mouse.Y, ColorY, ColorYM)
					local Code = ((Value - ColorY) / (ColorYM - ColorY));

					Airflow.Features.ColorDefault = Color3.fromHSV(Code, CodeH, CodeV);

					if Airflow.Features.Callback then
						task.spawn(Airflow.Features.Callback,Airflow.Features.ColorDefault)	
					end;

					Airflow:CreateAnimation(move,0.5,nil,{
						Position = UDim2.new(0.5,0,Code,0)
					})

					Airflow:CreateAnimation(ColorPick,0.5,nil,{
						BackgroundColor3 = Color3.fromHSV(Code, 1, 1)
					});

					if Code > OldCode then
						Airflow:CreateAnimation(left,0.2,nil,{
							Rotation = 45
						})

						Airflow:CreateAnimation(right,0.2,nil,{
							Rotation = -45
						})
					elseif Code < OldCode then
						Airflow:CreateAnimation(left,0.2,nil,{
							Rotation = -45
						})

						Airflow:CreateAnimation(right,0.2,nil,{
							Rotation = 45
						})
					else
						Airflow:CreateAnimation(left,0.2,nil,{
							Rotation = 0
						})

						Airflow:CreateAnimation(right,0.2,nil,{
							Rotation = 0
						})
					end;

					OldCode = Code;
				end;

				Airflow:CreateAnimation(left,0.5,nil,{
					Rotation = 0
				})

				Airflow:CreateAnimation(right,0.5,nil,{
					Rotation = 0
				})
			end;
		end);

		ColorPick.InputBegan:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
				IsPressM1 = true;

				while (UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton1) or IsPressM1) do task.wait();
					local PosX = ColorPick.AbsolutePosition.X
					local ScaleX = PosX + ColorPick.AbsoluteSize.X
					local Value, PosY = math.clamp(Mouse.X, PosX, ScaleX), ColorPick.AbsolutePosition.Y
					local ScaleY = PosY + ColorPick.AbsoluteSize.Y
					local Vals = math.clamp(Mouse.Y, PosY, ScaleY)

					CodeH = (Value - PosX) / (ScaleX - PosX);
					CodeV = (1 - ((Vals - PosY) / (ScaleY - PosY)));

					Airflow.Features.ColorDefault = Color3.fromHSV(OldCode, CodeH, CodeV);

					if Airflow.Features.Callback then
						task.spawn(Airflow.Features.Callback,Airflow.Features.ColorDefault)	
					end;

					Airflow:CreateAnimation(mouse,0.2,nil,{
						Position = UDim2.new(CodeH, 0, 1 - CodeV, 0)
					})
				end
			end
		end)
	end;

	function Airflow.Features:SetColor(Color : Color3)
		local H , S , V = Color:ToHSV();
		Airflow.Features.ColorDefault = Color;

		OldCode = H;
		CodeH = S;
		CodeV = V;
	end;

	function Airflow.Features:SetPosition(Position : UDim2)
		Airflow:CreateAnimation(ColorPicker,0.5,nil,{
			Position = Position
		})
	end;

	function Airflow.Features:OnColorPicker(Value : boolean)
		Airflow.Features.ColorPickerToggle = Value;

		if Value then
			local H , S , V = Airflow.Features.ColorDefault:ToHSV();

			Airflow:CreateAnimation(ColorPicker,0.5,nil,{
				BackgroundTransparency = 0.2,
				Size = UDim2.new(0.100000001, 100, 0.100000001, 100),
			})

			Airflow:CreateAnimation(UIStroke,0.5,nil,{
				Transparency = 0.570
			})

			Airflow:CreateAnimation(ColorPick,0.75,nil,{
				ImageTransparency = 0;
				BackgroundTransparency = 0;
				BackgroundColor3 = Color3.fromHSV(H,1,1);
			})

			Airflow:CreateAnimation(mouse,0.5,nil,{
				ImageTransparency = 0;
				Position = UDim2.new(S, 0,1 - V, 0)
			})

			Airflow:CreateAnimation(ColorSelect,0.5,nil,{
				BackgroundTransparency = 0;
			})

			Airflow:CreateAnimation(move,0.5,nil,{
				Position = UDim2.new(0.5,0,H,0)
			})

			Airflow:CreateAnimation(ColorSelect,0.5,nil,{
				BackgroundTransparency = 0;
			})

			Airflow:CreateAnimation(left,0.5,nil,{
				BackgroundTransparency = 0;
			})

			Airflow:CreateAnimation(right,0.5,nil,{
				BackgroundTransparency = 0;
			})

			Airflow:CreateAnimation(Copy,0.5,nil,{
				BackgroundTransparency = 0.8;
			})

			Airflow:CreateAnimation(Paste,0.5,nil,{
				BackgroundTransparency = 0.8;
			})

			Airflow:CreateAnimation(Paste,0.5,nil,{
				BackgroundTransparency = 0.8;
			})

			Airflow:CreateAnimation(Text,0.5,nil,{
				TextTransparency = 0;
			})

			Airflow:CreateAnimation(Text_2,0.5,nil,{
				TextTransparency = 0;
			})
		else
			Airflow.Features.Callback = nil;

			Airflow:CreateAnimation(move,0.5,nil,{
				Position = UDim2.new(0.5,0,0,0)
			})

			Airflow:CreateAnimation(ColorPicker,0.5,nil,{
				BackgroundTransparency = 1,
				Size = UDim2.new(0.100000001 , 85, 0.100000001, 85)
			})

			Airflow:CreateAnimation(UIStroke,0.5,nil,{
				Transparency = 1
			})

			Airflow:CreateAnimation(ColorPick,0.5,nil,{
				ImageTransparency = 1;
				BackgroundTransparency = 1;
				BackgroundColor3 = Color3.fromRGB(0,0,0)
			})

			Airflow:CreateAnimation(mouse,0.5,nil,{
				ImageTransparency = 1;
				Position = UDim2.new(0,0,0,0)
			})

			Airflow:CreateAnimation(ColorSelect,0.5,nil,{
				BackgroundTransparency = 1;
			})

			Airflow:CreateAnimation(ColorSelect,0.5,nil,{
				BackgroundTransparency = 1;
			})

			Airflow:CreateAnimation(left,0.5,nil,{
				BackgroundTransparency = 1;
			})

			Airflow:CreateAnimation(right,0.5,nil,{
				BackgroundTransparency = 1;
			})

			Airflow:CreateAnimation(Copy,0.5,nil,{
				BackgroundTransparency = 1;
			})

			Airflow:CreateAnimation(Paste,0.5,nil,{
				BackgroundTransparency = 1;
			})

			Airflow:CreateAnimation(Paste,0.5,nil,{
				BackgroundTransparency = 1;
			})

			Airflow:CreateAnimation(Text,0.5,nil,{
				TextTransparency = 1;
			})

			Airflow:CreateAnimation(Text_2,0.5,nil,{
				TextTransparency = 1;
			})
		end;
	end;

	Airflow.Features:OnColorPicker(false)
end;

function Airflow:Elements(element : Frame,OnChange : BindableEvent , windowConfig: {[string]: any}) : Elements
	local elements = {};
	local delayTick = 0.05;
	local ElementConfigs = {};
	local ElementId = 1;
	local ElementIDs = {};

	function elements:AddLabel(name)
		local LabelFrame = Instance.new("TextLabel")
		local ID = ElementId;

		LabelFrame.Name = Airflow:RandomString()
		LabelFrame.Parent = element
		LabelFrame.AnchorPoint = Vector2.new(0, 0.5)
		LabelFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		LabelFrame.BackgroundTransparency = 1.000
		LabelFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		LabelFrame.BorderSizePixel = 0
		LabelFrame.Position = UDim2.new(0, 30, 0.5, 0)
		LabelFrame.Size = UDim2.new(1, -10, 0, 17)
		LabelFrame.ZIndex = 7
		LabelFrame.Font = Enum.Font.GothamMedium
		LabelFrame.Text = name
		LabelFrame.TextColor3 = Color3.fromRGB(255, 255, 255)
		LabelFrame.TextSize = 13.000
		LabelFrame.TextWrapped = true
		LabelFrame.TextXAlignment = Enum.TextXAlignment.Left
		LabelFrame.TextTransparency = 1;

		if OnChange:GetAttribute('Value') then
			task.delay(0.3,Airflow.CreateAnimation,Airflow,LabelFrame,0.5,nil,{
				TextTransparency = 0;
			})
		end;

		local VisibleAnimation = function(value)
			if value then
				task.wait(delayTick);

				Airflow:CreateAnimation(LabelFrame,1.2,nil,{
					TextTransparency = 0;
				})
			else
				Airflow:CreateAnimation(LabelFrame,0.5,nil,{
					TextTransparency = 1;
				})
			end
		end;

		LabelFrame:GetPropertyChangedSignal('TextTransparency'):Connect(function()
			if LabelFrame.TextTransparency >= 0.9 then
				LabelFrame.Visible = false;
			else
				LabelFrame.Visible = true;
			end;
		end);

		ElementId += 1;

		local tableback = {
			Edit = function(self , Value)
				LabelFrame.Text = Value				
			end,
			Visible = function(self , Value)
				LabelFrame.Visible = Value	
			end,
			Destroy = function(self)
				LabelFrame:Destroy();		
			end,
			ID = ID,
			Signal = OnChange.Event:Connect(VisibleAnimation)
		};

		ElementIDs[ID] = {
			Name = name,
			ID = ID,
			Type = "Label",
			API = tableback,
		};

		return tableback;
	end;

	function elements:AddButton(config)
		config = config or {};
		config.Name = config.Name or "Button";
		config.Callback = config.Callback or function() end;

		local ID = ElementId;
		local ButtonFrame = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local PText = Instance.new("TextLabel")

		ButtonFrame.Name = Airflow:RandomString()
		ButtonFrame.Parent = element
		ButtonFrame.BackgroundColor3 = Color3.fromRGB(91, 91, 91)
		ButtonFrame.BackgroundTransparency = 1
		ButtonFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ButtonFrame.BorderSizePixel = 0
		ButtonFrame.ClipsDescendants = true
		ButtonFrame.Size = UDim2.new(1, -6, 0, 30)
		ButtonFrame.ZIndex = 6

		UICorner.CornerRadius = UDim.new(0, 4)
		UICorner.Parent = ButtonFrame

		PText.Name = Airflow:RandomString()
		PText.Parent = ButtonFrame
		PText.AnchorPoint = Vector2.new(0.5, 0.5)
		PText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		PText.BackgroundTransparency = 1.000
		PText.BorderColor3 = Color3.fromRGB(0, 0, 0)
		PText.BorderSizePixel = 0
		PText.Position = UDim2.new(0.5, 0, 0.5, 0)
		PText.Size = UDim2.new(1, -20, 0, 20)
		PText.ZIndex = 7
		PText.Font = Enum.Font.GothamMedium
		PText.Text = config.Name
		PText.TextColor3 = Color3.fromRGB(255, 255, 255)
		PText.TextSize = 14.000
		PText.TextWrapped = true
		PText.TextTransparency = 1

		Airflow:NewInput(ButtonFrame,config.Callback);
		Airflow:Hover(ButtonFrame);

		if OnChange:GetAttribute('Value') then
			task.delay(0.5,Airflow.CreateAnimation,Airflow,PText,0.5,nil,{
				TextTransparency = 0
			})

			task.delay(0.4,Airflow.CreateAnimation,Airflow,ButtonFrame,0.5,nil,{
				BackgroundTransparency = 0.800,
				Size = UDim2.new(1, -2, 0, 34)
			});
		end;

		local VisibleAnimation = function(value)
			if value then
				task.wait(delayTick);

				Airflow:CreateAnimation(ButtonFrame,0.7,nil,{
					BackgroundTransparency = 0.800,
					Size = UDim2.new(1, -2, 0, 34)
				})

				Airflow:CreateAnimation(PText,0.7,nil,{
					TextTransparency = 0
				})
			else
				Airflow:CreateAnimation(PText,0.6,nil,{
					TextTransparency = 1
				})

				Airflow:CreateAnimation(ButtonFrame,0.5,nil,{
					BackgroundTransparency = 1,
					Size = UDim2.new(1, -6, 0, 34)
				})
			end
		end;

		ElementId += 1;

		local tableback = {
			Edit = function(self , Value)
				PText.Text = Value				
			end,
			Visible = function(self , Value)
				ButtonFrame.Visible = Value	
			end,
			Fire = config.Callback,
			Destroy = function(self)
				ButtonFrame:Destroy();		
			end,
			Signal = OnChange.Event:Connect(VisibleAnimation)
		};

		ElementIDs[ID] = {
			Name = config.Name,
			ID = ID,
			Type = "Button",
			API = tableback,
		};

		return tableback
	end;

	function elements:AddToggle(config)
		config = config or {};
		config.Name = config.Name or "Toggle";
		config.Callback = config.Callback or function() end;
		config.Default = config.Default or false;

		local ID = ElementId;
		local ToggleFrame = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local PText = Instance.new("TextLabel")
		local block = Instance.new("Frame")
		local UICorner_2 = Instance.new("UICorner")
		local circle = Instance.new("Frame")
		local UICorner_3 = Instance.new("UICorner")

		ToggleFrame.Name = Airflow:RandomString()
		ToggleFrame.Parent = element
		ToggleFrame.BackgroundColor3 = Color3.fromRGB(91, 91, 91)
		ToggleFrame.BackgroundTransparency = 1
		ToggleFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ToggleFrame.BorderSizePixel = 0
		ToggleFrame.ClipsDescendants = true
		ToggleFrame.Size = UDim2.new(1, -6, 0, 30)
		ToggleFrame.ZIndex = 6

		UICorner.CornerRadius = UDim.new(0, 4)
		UICorner.Parent = ToggleFrame

		PText.Name = Airflow:RandomString()
		PText.Parent = ToggleFrame
		PText.AnchorPoint = Vector2.new(0, 0.5)
		PText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		PText.BackgroundTransparency = 1.000
		PText.BorderColor3 = Color3.fromRGB(0, 0, 0)
		PText.BorderSizePixel = 0
		PText.Position = UDim2.new(0, 10, 0.5, 0)
		PText.Size = UDim2.new(1, 50, 0, 20)
		PText.ZIndex = 7
		PText.Font = Enum.Font.GothamMedium
		PText.Text = config.Name;
		PText.TextColor3 = Color3.fromRGB(255, 255, 255)
		PText.TextSize = 13.000
		PText.TextTransparency = 1
		PText.TextWrapped = true
		PText.TextXAlignment = Enum.TextXAlignment.Left

		block.Name = Airflow:RandomString()
		block.Parent = ToggleFrame
		block.AnchorPoint = Vector2.new(1, 0.5)
		block.BackgroundColor3 = Color3.fromRGB(36, 35, 35)
		block.BackgroundTransparency = 1
		block.BorderColor3 = Color3.fromRGB(0, 0, 0)
		block.BorderSizePixel = 0
		block.Position = UDim2.new(1, -10, 0.5, 0)
		block.Size = UDim2.new(0, 35, 0, 16)
		block.ZIndex = 7

		UICorner_2.CornerRadius = UDim.new(1, 0)
		UICorner_2.Parent = block

		circle.Name = Airflow:RandomString()
		circle.Parent = block
		circle.AnchorPoint = Vector2.new(0.5, 0.5)
		circle.BackgroundColor3 = windowConfig.Hightlight or Color3.fromRGB(163, 128, 216)
		circle.BorderColor3 = Color3.fromRGB(0, 0, 0)
		circle.BorderSizePixel = 0
		circle.Position = UDim2.new(0.75, 0, 0.5, 0)
		circle.Size = UDim2.new(0.699999988, 0, 0.699999988, 0)
		circle.SizeConstraint = Enum.SizeConstraint.RelativeYY
		circle.ZIndex = 8
		circle.BackgroundTransparency = 1;

		UICorner_3.CornerRadius = UDim.new(1, 0)
		UICorner_3.Parent = circle

		if OnChange:GetAttribute('Value') then
			task.delay(0.5,Airflow.CreateAnimation,Airflow,circle,0.5,nil,{
				BackgroundTransparency = 0
			})
			task.delay(0.5,Airflow.CreateAnimation,Airflow,block,0.5,nil,{
				BackgroundTransparency = 0.5
			})
			task.delay(0.5,Airflow.CreateAnimation,Airflow,PText,0.5,nil,{
				TextTransparency = 0.3
			})
			task.delay(0.4,Airflow.CreateAnimation,Airflow,ToggleFrame,0.5,nil,{
				BackgroundTransparency = 0.800,
				Size = UDim2.new(1, -2, 0, 34)
			})
		end;

		local Change = function(value)
			if value then
				Airflow:CreateAnimation(circle,0.5,nil,{
					BackgroundColor3 = windowConfig.Hightlight or Color3.fromRGB(163, 128, 216),
					Position = UDim2.new(0.75, 0, 0.5, 0)
				});
			else
				Airflow:CreateAnimation(circle,0.5,nil,{
					BackgroundColor3 = Color3.fromRGB(216, 216, 216),
					Position = UDim2.new(0.25, 0, 0.5, 0)
				});
			end;
		end;

		Change(config.Default);

		ElementConfigs["Toggle_"..config.Name.."_"..tostring(ID)] = {
			Value = config.Default;
		};

		local BindableToggle = Instance.new("BindableEvent",ToggleFrame);
		Airflow:NewInput(ToggleFrame,function()
			config.Default = not config.Default;

			BindableToggle:Fire(config.Default);

			ElementConfigs["Toggle_"..config.Name.."_"..tostring(ID)] = {
				Value = config.Default;
			};

			Change(config.Default)
			config.Callback(config.Default)
		end);

		Airflow:Hover(ToggleFrame);

		ElementId += 1;

		local tableback = {
			Edit = function(self , Value)
				PText.Text = Value				
			end,

			SetValue = function(self , Value)
				config.Default = Value;
				Change(config.Default);

				ElementConfigs["Toggle_"..config.Name.."_"..tostring(ID)] = {
					Value = config.Default;
				};

				BindableToggle:Fire(config.Default);

				config.Callback(config.Default)
			end,

			Visible = function(self , Value)
				ToggleFrame.Visible = Value		
			end,

			AutomaticVisible = function(self , config) : RBXScriptSignal
				config = config or {};
				config.Target = config.Target;
				config.Elements = config.Elements or {};

				local callback = function(val)
					if val == config.Target then
						for i ,v in next , config.Elements do
							v:Visible(true);
						end;
					else
						for i ,v in next , config.Elements do
							v:Visible(false);
						end;
					end;
				end;

				callback(config.Default);

				return BindableToggle.Event:Connect(callback);
			end,

			Destroy = function(self)
				ToggleFrame:Destroy();		
			end,

			Signal = OnChange.Event:Connect(function(value)
				if value then
					task.wait(delayTick);

					Airflow:CreateAnimation(ToggleFrame,0.7,nil,{
						BackgroundTransparency = 0.800,
						Size = UDim2.new(1, -2, 0, 34)
					})

					Airflow:CreateAnimation(PText,0.7,nil,{
						TextTransparency = 0.3
					})

					Airflow:CreateAnimation(block,0.7,nil,{
						BackgroundTransparency = 0.5
					});

					Airflow:CreateAnimation(circle,0.7,nil,{
						BackgroundTransparency = 0
					})

					Change(config.Default);
				else
					Change(false);

					Airflow:CreateAnimation(block,0.5,nil,{
						BackgroundTransparency = 1
					});

					Airflow:CreateAnimation(circle,0.5,nil,{
						BackgroundTransparency = 1
					})

					Airflow:CreateAnimation(PText,0.5,nil,{
						TextTransparency = 1
					})

					Airflow:CreateAnimation(ToggleFrame,0.5,nil,{
						BackgroundTransparency = 1,
						Size = UDim2.new(1, -6, 0, 34)
					})
				end
			end)
		};

		ElementIDs[ID] = {
			Name = config.Name,
			ID = ID,
			Type = "Toggle",
			API = tableback,
			IDCode = "Toggle_"..config.Name.."_"..tostring(ID),
		};

		return tableback
	end;

	function elements:AddSlider(config)
		config = config or {};
		config.Name = config.Name or "Slider";
		config.Callback = config.Callback or function() end;
		config.Min = config.Min or 0;
		config.Max = config.Max or 100;
		config.Round = config.Round or 0;
		config.Default = config.Default or config.Min;
		config.Type = config.Type or "";
		config.ValueTexts = config.ValueTexts or {};

		local ID = ElementId;
		local SliderFrame = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local PText = Instance.new("TextLabel")
		local VText = Instance.new("TextLabel")
		local wheel = Instance.new("Frame")
		local UICorner_2 = Instance.new("UICorner")
		local slide = Instance.new("Frame")
		local UICorner_3 = Instance.new("UICorner")
		local UIGradient = Instance.new("UIGradient")
		local bth = Instance.new("Frame")
		local UICorner_4 = Instance.new("UICorner")
		local UIStroke = Instance.new("UIStroke")

		SliderFrame.Name = Airflow:RandomString()
		SliderFrame.Parent = element
		SliderFrame.BackgroundColor3 = Color3.fromRGB(91, 91, 91)
		SliderFrame.BackgroundTransparency = 1
		SliderFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		SliderFrame.BorderSizePixel = 0
		SliderFrame.Size = UDim2.new(1, -6, 0, 44)
		SliderFrame.ZIndex = 6

		UICorner.CornerRadius = UDim.new(0, 4)
		UICorner.Parent = SliderFrame

		PText.Name = Airflow:RandomString()
		PText.Parent = SliderFrame
		PText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		PText.BackgroundTransparency = 1.000
		PText.BorderColor3 = Color3.fromRGB(0, 0, 0)
		PText.BorderSizePixel = 0
		PText.Position = UDim2.new(0, 10, 0, 7)
		PText.Size = UDim2.new(1, 50, 0, 20)
		PText.ZIndex = 7
		PText.Font = Enum.Font.GothamMedium
		PText.Text = config.Name
		PText.TextColor3 = Color3.fromRGB(255, 255, 255)
		PText.TextSize = 13.000
		PText.TextTransparency = 1
		PText.TextWrapped = true
		PText.TextXAlignment = Enum.TextXAlignment.Left

		VText.Name = Airflow:RandomString()
		VText.Parent = SliderFrame
		VText.AnchorPoint = Vector2.new(1, 0)
		VText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		VText.BackgroundTransparency = 1.000
		VText.BorderColor3 = Color3.fromRGB(0, 0, 0)
		VText.BorderSizePixel = 0
		VText.Position = UDim2.new(1, -10, 0, 7)
		VText.Size = UDim2.new(1, -30, 0, 20)
		VText.ZIndex = 7
		VText.Font = Enum.Font.GothamMedium
		VText.Text = tostring(config.Default)..tostring(config.Type)
		VText.TextColor3 = Color3.fromRGB(255, 255, 255)
		VText.TextSize = 13.000
		VText.TextWrapped = true
		VText.TextXAlignment = Enum.TextXAlignment.Right
		VText.TextTransparency = 1;

		wheel.Name = Airflow:RandomString()
		wheel.Parent = SliderFrame
		wheel.AnchorPoint = Vector2.new(0.5, 1)
		wheel.BackgroundColor3 = Color3.fromRGB(43, 43, 43)
		wheel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		wheel.BorderSizePixel = 0
		wheel.Position = UDim2.new(0.5, 0, 1, -11)
		wheel.Size = UDim2.new(1, -25, 0, 7)
		wheel.ZIndex = 7
		wheel.BackgroundTransparency = 1;

		UICorner_2.CornerRadius = UDim.new(0, 4)
		UICorner_2.Parent = wheel

		slide.Name = Airflow:RandomString()
		slide.Parent = wheel
		slide.BackgroundColor3 = windowConfig.Hightlight or Color3.fromRGB(163, 128, 216)
		slide.BorderColor3 = Color3.fromRGB(0, 0, 0)
		slide.BorderSizePixel = 0
		slide.Size = UDim2.new((config.Default - config.Min) / (config.Max - config.Min), 0, 1, 0)
		slide.ZIndex = 8
		slide.BackgroundTransparency = 1;

		UICorner_3.CornerRadius = UDim.new(0, 4)
		UICorner_3.Parent = slide

		UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(165, 165, 165)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(255, 255, 255))}
		UIGradient.Parent = slide

		bth.Name = Airflow:RandomString()
		bth.Parent = slide
		bth.AnchorPoint = Vector2.new(1, 0.5)
		bth.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		bth.BorderColor3 = Color3.fromRGB(0, 0, 0)
		bth.BorderSizePixel = 0
		bth.Position = UDim2.new(1, 5, 0.5, 0)
		bth.Size = UDim2.new(0, 10, 0, 10)
		bth.ZIndex = 9
		bth.BackgroundTransparency = 1

		UICorner_4.CornerRadius = UDim.new(1, 0)
		UICorner_4.Parent = bth

		UIStroke.Thickness = 4.000
		UIStroke.Transparency = 1
		UIStroke.Color = Color3.fromRGB(255, 255, 255)
		UIStroke.Parent = bth	

		if OnChange:GetAttribute('Value') then
			task.delay(0.7,Airflow.CreateAnimation,Airflow,UIStroke,0.5,nil,{
				Transparency = 0.9,
			})

			task.delay(0.6,Airflow.CreateAnimation,Airflow,bth,0.5,nil,{
				BackgroundTransparency = 0,
			})

			task.delay(0.55,Airflow.CreateAnimation,Airflow,slide,0.5,nil,{
				BackgroundTransparency = 0,
			})

			task.delay(0.5,Airflow.CreateAnimation,Airflow,wheel,0.5,nil,{
				BackgroundTransparency = 0,
			})

			task.delay(0.5,Airflow.CreateAnimation,Airflow,VText,0.5,nil,{
				TextTransparency = 0,
			})

			task.delay(0.5,Airflow.CreateAnimation,Airflow,PText,0.5,nil,{
				TextTransparency = 0.3,
			})

			task.delay(0.4,Airflow.CreateAnimation,Airflow,SliderFrame,0.5,nil,{
				BackgroundTransparency = 0.800,
				Size = UDim2.new(1, -2, 0, 50)
			})
		end

		Airflow:Hover(SliderFrame)

		ElementConfigs["Slider_"..config.Name.."_"..tostring(ID)] = {
			Value = config.Default,
		};

		local IsHold = false;

		local function update(Input)
			local SizeScale = math.clamp((((Input.Position.X) - wheel.AbsolutePosition.X) / wheel.AbsoluteSize.X), 0, 1);
			local Main = ((config.Max - config.Min) * SizeScale) + config.Min;
			local Value = Airflow:Rounding(Main,config.Round);
			local PositionX = UDim2.fromScale(SizeScale, 1);
			local normalized = (Value - config.Min) / (config.Max - config.Min);

			TweenService:Create(slide , TweenInfo.new(0.2),{
				Size = UDim2.new(normalized, 0, 1, 0)
			}):Play();

			config.Default = Value;
			VText.Text = (config.ValueTexts[Value] and config.ValueTexts[Value]) or tostring(Value)..tostring(config.Type);

			ElementConfigs["Slider_"..config.Name.."_"..tostring(ID)] = {
				Value = config.Default,
			};

			config.Callback(Value)
		end;

		wheel.InputBegan:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
				IsHold = true
				update(Input)
			end
		end)

		wheel.InputEnded:Connect(function(Input)
			if Input.UserInputType == Enum.UserInputType.MouseButton1 or Input.UserInputType == Enum.UserInputType.Touch then
				if UserInputService.TouchEnabled then
					if not Airflow:IsMouseOverFrame(SliderFrame) then
						IsHold = false
					end;
				else
					IsHold = false
				end;
			end
		end)

		UserInputService.InputChanged:Connect(function(Input)
			if IsHold then
				if (Input.UserInputType == Enum.UserInputType.MouseMovement or Input.UserInputType == Enum.UserInputType.Touch)  then
					if UserInputService.TouchEnabled then
						if not Airflow:IsMouseOverFrame(SliderFrame) then
							IsHold = false
						else
							update(Input)
						end;
					else
						update(Input)
					end;
				end;
			end;
		end);

		ElementId += 1;

		local tableback = {
			Edit = function(self , Value)
				PText.Text = Value				
			end,

			SetValue = function(self , Value)
				config.Default = Value;
				slide.Size = UDim2.new((config.Default - config.Min) / (config.Max - config.Min), 0, 1, 0);
				VText.Text = (config.ValueTexts[Value] and config.ValueTexts[Value]) or tostring(Value)..tostring(config.Type);

				ElementConfigs["Slider_"..config.Name.."_"..tostring(ID)] = {
					Value = config.Default,
				};

				config.Callback(Value)
			end,

			Visible = function(self , Value)
				SliderFrame.Visible = Value		
			end,

			Destroy = function(self)
				SliderFrame:Destroy();		
			end,

			Signal = OnChange.Event:Connect(function(value)
				if value then
					task.wait(delayTick);

					Airflow:CreateAnimation(SliderFrame,0.7,nil,{
						BackgroundTransparency = 0.800,
						Size = UDim2.new(1, -2, 0, 50)
					})

					Airflow:CreateAnimation(PText,0.7,nil,{
						TextTransparency = 0.3
					})

					Airflow:CreateAnimation(VText,0.6,nil,{
						TextTransparency = 0,
					})

					Airflow:CreateAnimation(wheel,0.7,nil,{
						BackgroundTransparency = 0,
					})

					Airflow:CreateAnimation(slide,0.7,nil,{
						BackgroundTransparency = 0,
						Size = UDim2.new((config.Default - config.Min) / (config.Max - config.Min), 0, 1, 0)
					})

					Airflow:CreateAnimation(bth,0.6,nil,{
						BackgroundTransparency = 0,
					})

					Airflow:CreateAnimation(UIStroke,0.7,nil,{
						Transparency = 0.9,
					})
				else
					Airflow:CreateAnimation(SliderFrame,0.5,nil,{
						BackgroundTransparency = 1,
						Size = UDim2.new(1, -6, 0, 50)
					})

					Airflow:CreateAnimation(PText,0.5,nil,{
						TextTransparency = 1
					})

					Airflow:CreateAnimation(VText,0.5,nil,{
						TextTransparency = 1,
					})

					Airflow:CreateAnimation(wheel,0.5,nil,{
						BackgroundTransparency = 1,
					})

					Airflow:CreateAnimation(slide,0.5,nil,{
						BackgroundTransparency = 1,
						Size = UDim2.new(0, 0, 1, 0)
					})

					Airflow:CreateAnimation(bth,0.5,nil,{
						BackgroundTransparency = 1,
					})

					Airflow:CreateAnimation(UIStroke,0.5,nil,{
						Transparency = 1,
					})
				end
			end)
		};

		ElementIDs[ID] = {
			Name = config.Name,
			ID = ID,
			Type = "Slider",
			API = tableback,
			IDCode = "Slider_"..config.Name.."_"..tostring(ID),
		};

		return tableback
	end;

	function elements:AddKeybind(config)
		config = config or {};
		config.Name = config.Name or "Keybind";
		config.Callback = config.Callback or function() end;
		config.Default = config.Default or "None";

		local Keys = {
			One = '1',
			Two = '2',
			Three = '3',
			Four = '4',
			Five = '5',
			Six = '6',
			Seven = '7',
			Eight = '8',
			Nine = '9',
			Zero = '0',
			['Minus'] = "-",
			['Plus'] = "+",
			BackSlash = "\\",
			Slash = "/",
			Period = '.',
			Semicolon = ';',
			Colon = ":",
			LeftControl = "LCtrl",
			RightControl = "RCtrl",
			LeftShift = "LShift",
			RightShift = "RShift",
			Return = "Enter",
			LeftBracket = "[",
			RightBracket = "]",
			Quote = "'",
			Comma = ",",
			Equals = "=",
			LeftSuper = "Windows"
		};

		local ID = ElementId;
		local GetItem = function(item)
			if item then
				if typeof(item) == 'EnumItem' then
					return Keys[item.Name] or item.Name;
				else
					return Keys[tostring(item)] or tostring(item);
				end;
			else
				return 'NONE';
			end;
		end;

		local KeybindFrame = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local PText = Instance.new("TextLabel")
		local block = Instance.new("Frame")
		local UICorner_2 = Instance.new("UICorner")
		local VText = Instance.new("TextLabel")

		KeybindFrame.Name = Airflow:RandomString()
		KeybindFrame.Parent = element
		KeybindFrame.BackgroundColor3 = Color3.fromRGB(91, 91, 91)
		KeybindFrame.BackgroundTransparency = 1
		KeybindFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		KeybindFrame.BorderSizePixel = 0
		KeybindFrame.ClipsDescendants = true
		KeybindFrame.Size = UDim2.new(1, -6, 0, 30)
		KeybindFrame.ZIndex = 6

		UICorner.CornerRadius = UDim.new(0, 4)
		UICorner.Parent = KeybindFrame

		PText.Name = Airflow:RandomString()
		PText.Parent = KeybindFrame
		PText.AnchorPoint = Vector2.new(0, 0.5)
		PText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		PText.BackgroundTransparency = 1.000
		PText.BorderColor3 = Color3.fromRGB(0, 0, 0)
		PText.BorderSizePixel = 0
		PText.Position = UDim2.new(0, 10, 0.5, 0)
		PText.Size = UDim2.new(1, 50, 0, 20)
		PText.ZIndex = 7
		PText.Font = Enum.Font.GothamMedium
		PText.Text = config.Name
		PText.TextColor3 = Color3.fromRGB(255, 255, 255)
		PText.TextSize = 13.000
		PText.TextTransparency = 1
		PText.TextWrapped = true
		PText.TextXAlignment = Enum.TextXAlignment.Left

		block.Name = Airflow:RandomString()
		block.Parent = KeybindFrame
		block.AnchorPoint = Vector2.new(1, 0.5)
		block.BackgroundColor3 = Color3.fromRGB(50, 49, 48)
		block.BackgroundTransparency = 1
		block.BorderColor3 = Color3.fromRGB(0, 0, 0)
		block.BorderSizePixel = 0
		block.Position = UDim2.new(1, -10, 0.5, 0)
		block.Size = UDim2.new(0, 55, 0, 22)
		block.ZIndex = 7

		UICorner_2.CornerRadius = UDim.new(0, 5)
		UICorner_2.Parent = block

		VText.Name = Airflow:RandomString()
		VText.Parent = block
		VText.AnchorPoint = Vector2.new(0.5, 0.5)
		VText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		VText.BackgroundTransparency = 1.000
		VText.BorderColor3 = Color3.fromRGB(0, 0, 0)
		VText.BorderSizePixel = 0
		VText.Position = UDim2.new(0.5, 0, 0.5, 0)
		VText.Size = UDim2.new(1, -10, 0, 20)
		VText.ZIndex = 7
		VText.Font = Enum.Font.GothamMedium
		VText.Text = GetItem(config.Default);
		VText.TextColor3 = Color3.fromRGB(255, 255, 255)
		VText.TextSize = 13.000
		VText.TextWrapped = true
		VText.TextTransparency = 1;

		if OnChange:GetAttribute('Value') then
			task.delay(0.5,Airflow.CreateAnimation,Airflow,VText,0.5,nil,{
				TextTransparency = 0,
			})

			task.delay(0.5,Airflow.CreateAnimation,Airflow,block,0.5,nil,{
				BackgroundTransparency = 0.5,
			})

			task.delay(0.5,Airflow.CreateAnimation,Airflow,PText,0.5,nil,{
				TextTransparency = 0.3,
			})

			task.delay(0.4,Airflow.CreateAnimation,Airflow,KeybindFrame,0.5,nil,{
				BackgroundTransparency = 0.800,
				Size = UDim2.new(1, -2, 0, 35)
			})
		end;

		Airflow:Hover(KeybindFrame);

		local UpdateScale = function()
			local BindLabelScale = TextService:GetTextSize(VText.Text,VText.TextSize,VText.Font,Vector2.new(math.huge,math.huge));

			TweenService:Create(block,TweenInfo.new(0.1),{
				Size = UDim2.new(0, BindLabelScale.X + 22, 0, 22)
			}):Play();
		end;

		UpdateScale();

		local IsBinding = false;
		Airflow:NewInput(block,function()
			if IsBinding then
				return;
			end;

			VText.Text = "...";

			UpdateScale();

			local Selected = nil;
			while not Selected do
				local Key = UserInputService.InputBegan:Wait();

				if Key.KeyCode ~= Enum.KeyCode.Unknown then
					Selected = Key.KeyCode;
				else
					if Key.UserInputType == Enum.UserInputType.MouseButton1 then
						Selected = "MouseLeft";
					elseif Key.UserInputType == Enum.UserInputType.MouseButton2 then
						Selected = "MouseRight";
					end;
				end;
			end;

			config.Default = Selected;

			VText.Text = GetItem(Selected);

			UpdateScale();

			IsBinding = false;

			ElementConfigs["Keybind_"..config.Name.."_"..tostring(ID)] = {
				Value = (typeof(Selected) == "string" and Selected or Selected.Name),
			};

			config.Callback(typeof(Selected) == "string" and Selected or Selected.Name);
		end);

		ElementConfigs["Keybind_"..config.Name.."_"..tostring(ID)] = {
			Value = (typeof(config.Default) == "string" and config.Default or config.Default.Name),
		};

		ElementId += 1;

		local tableback  ={
			Edit = function(self , Value)
				PText.Text = Value				
			end,

			SetValue = function(self , Value)
				config.Default = Value;
				VText.Text = GetItem(config.Default);

				UpdateScale();

				local Key = (typeof(config.Default) == "string" and config.Default or config.Default.Name);

				ElementConfigs["Keybind_"..config.Name.."_"..tostring(ID)] = {
					Value = Key,
				};

				config.Callback(Key);
			end,

			Visible = function(self , Value)
				KeybindFrame.Visible = Value		
			end,

			Destroy = function(self)
				KeybindFrame:Destroy();		
			end,

			Signal = OnChange.Event:Connect(function(value)
				if value then
					task.wait(delayTick);

					Airflow:CreateAnimation(KeybindFrame,0.7,nil,{
						BackgroundTransparency = 0.800,
						Size = UDim2.new(1, -2, 0, 35)
					})

					Airflow:CreateAnimation(block,0.6,nil,{
						BackgroundTransparency = 0.5,
					})

					Airflow:CreateAnimation(PText,0.7,nil,{
						TextTransparency = 0.3,
					})

					Airflow:CreateAnimation(VText,0.6,nil,{
						TextTransparency = 0,
					})
				else
					Airflow:CreateAnimation(KeybindFrame,0.5,nil,{
						BackgroundTransparency = 1,
						Size = UDim2.new(1, -6, 0, 35)
					})

					Airflow:CreateAnimation(block,0.5,nil,{
						BackgroundTransparency = 1,
					})

					Airflow:CreateAnimation(PText,0.5,nil,{
						TextTransparency = 1,
					})

					Airflow:CreateAnimation(VText,0.5,nil,{
						TextTransparency = 1,
					})
				end
			end)
		};

		ElementIDs[ID] = {
			Name = config.Name,
			ID = ID,
			Type = "Keybind",
			API = tableback,
			IDCode = "Keybind_"..config.Name.."_"..tostring(ID),
		};

		return tableback
	end;

	function elements:AddTextbox(config)
		config = config or {};
		config.Name = config.Name or "TextBox";
		config.Default = config.Default or "";
		config.Placeholder = config.Placeholder or "	";
		config.Numeric = config.Numeric or false;
		config.Finished = config.Finished or false;
		config.Callback = config.Callback or function() end;

		local ID = ElementId;

		local TextboxFrame = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local PText = Instance.new("TextLabel")
		local block = Instance.new("Frame")
		local UICorner_2 = Instance.new("UICorner")
		local TextBox = Instance.new("TextBox")

		TextboxFrame.Name = Airflow:RandomString()
		TextboxFrame.Parent = element
		TextboxFrame.BackgroundColor3 = Color3.fromRGB(91, 91, 91)
		TextboxFrame.BackgroundTransparency = 1
		TextboxFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextboxFrame.BorderSizePixel = 0
		TextboxFrame.ClipsDescendants = true
		TextboxFrame.Size = UDim2.new(1, -2, 0, 45)
		TextboxFrame.ZIndex = 6

		UICorner.CornerRadius = UDim.new(0, 4)
		UICorner.Parent = TextboxFrame

		PText.Name = Airflow:RandomString()
		PText.Parent = TextboxFrame
		PText.AnchorPoint = Vector2.new(0, 0.5)
		PText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		PText.BackgroundTransparency = 1.000
		PText.BorderColor3 = Color3.fromRGB(0, 0, 0)
		PText.BorderSizePixel = 0
		PText.Position = UDim2.new(0, 10, 0.5, 0)
		PText.Size = UDim2.new(1, 50, 0, 20)
		PText.ZIndex = 7
		PText.Font = Enum.Font.GothamMedium
		PText.Text = config.Name
		PText.TextColor3 = Color3.fromRGB(255, 255, 255)
		PText.TextSize = 13.000
		PText.TextTransparency = 1
		PText.TextWrapped = true
		PText.TextXAlignment = Enum.TextXAlignment.Left

		block.Name = Airflow:RandomString()
		block.Parent = TextboxFrame
		block.AnchorPoint = Vector2.new(1, 0.5)
		block.BackgroundColor3 = Color3.fromRGB(36, 35, 35)
		block.BackgroundTransparency = 1
		block.BorderColor3 = Color3.fromRGB(0, 0, 0)
		block.BorderSizePixel = 0
		block.ClipsDescendants = true
		block.Position = UDim2.new(1, -10, 0.5, 0)
		block.Size = UDim2.new(0, 65, 0, 25)
		block.ZIndex = 7

		UICorner_2.CornerRadius = UDim.new(0, 4)
		UICorner_2.Parent = block

		TextBox.Parent = block
		TextBox.AnchorPoint = Vector2.new(0.5, 0.5)
		TextBox.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		TextBox.BackgroundTransparency = 1.000
		TextBox.BorderColor3 = Color3.fromRGB(0, 0, 0)
		TextBox.BorderSizePixel = 0
		TextBox.Position = UDim2.new(0.5, 0, 0.5, 0)
		TextBox.Size = UDim2.new(1, -10, 1, -5)
		TextBox.ZIndex = 8
		TextBox.ClearTextOnFocus = false
		TextBox.Font = Enum.Font.GothamMedium
		TextBox.PlaceholderText = config.Placeholder
		TextBox.Text = config.Default
		TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
		TextBox.TextSize = 10.000
		TextBox.TextTransparency = 1;
		TextBox.TextXAlignment = Enum.TextXAlignment.Left

		local Update = function()
			local scale = TextService:GetTextSize(TextBox.Text,TextBox.TextSize,TextBox.Font,Vector2.new(math.huge,math.huge));
			local Base = TextService:GetTextSize(TextBox.PlaceholderText,TextBox.TextSize,TextBox.Font,Vector2.new(math.huge,math.huge));
			local Sty = TextService:GetTextSize(PText.Text,PText.TextSize,PText.Font,Vector2.new(math.huge,math.huge));

			local MainScale = ((scale.X > Base.X) and scale.X) or Base.X;

			if scale.X > (Base.X + 5) then
				TextBox.TextXAlignment = Enum.TextXAlignment.Left;
			else
				TextBox.TextXAlignment = Enum.TextXAlignment.Center;
			end;

			Airflow:CreateAnimation(block,0.3,nil,{
				Size = UDim2.new(0, math.min(MainScale + 10,TextboxFrame.AbsoluteSize.X - (Sty.X + 25)), 0, 25)
			})
		end;

		if OnChange:GetAttribute('Value') then
			task.delay(0.5,Airflow.CreateAnimation,Airflow,block,0.5,nil,{
				BackgroundTransparency = 0.500
			})

			task.delay(0.5,Airflow.CreateAnimation,Airflow,PText,0.5,nil,{
				TextTransparency = 0.3
			})

			task.delay(0.5,Airflow.CreateAnimation,Airflow,TextBox,0.5,nil,{
				TextTransparency = 0
			})

			task.delay(0.4,Airflow.CreateAnimation,Airflow,TextboxFrame,0.5,nil,{
				BackgroundTransparency = 0.800,
			})
		end;

		Update();

		TextBox:GetPropertyChangedSignal('Text'):Connect(Update);

		ElementConfigs["TextBox_"..config.Name.."_"..tostring(ID)] = {
			Value = config.Default,
		};

		local parse = function(text)
			if not text then
				return "";	
			end;

			if config.Numeric then
				local out = string.gsub(tostring(text), '[^0-9.]', '')

				if tonumber(out) then
					return tonumber(out);
				end;

				return nil;
			end;

			return text;
		end;

		Airflow:Hover(TextboxFrame);

		if config.Finished then

			TextBox:GetPropertyChangedSignal('Text'):Connect(function()
				TextBox.Text = parse(TextBox.Text);
			end);

			TextBox.FocusLost:Connect(function()
				local value = parse(TextBox.Text);

				if value then
					TextBox.Text = tostring(value);
					config.Callback(value);
				end;

				ElementConfigs["TextBox_"..config.Name.."_"..tostring(ID)] = {
					Value = value,
				};
			end)

		else
			TextBox:GetPropertyChangedSignal('Text'):Connect(function()
				local value = parse(TextBox.Text);

				if value then
					TextBox.Text = tostring(value);

					config.Callback(value);
				else
					TextBox.Text = string.gsub(TextBox.Text, '[^0-9.]', '');
				end;

				ElementConfigs["TextBox_"..config.Name.."_"..tostring(ID)] = {
					Value = value,
				};
			end);
		end;

		ElementId += 1;

		local tableback = {
			Edit = function(self , Value)
				PText.Text = Value;
			end,

			SetValue = function(self , value)
				TextBox.Text = parse(value);

				ElementConfigs["TextBox_"..config.Name.."_"..tostring(ID)] = {
					Value = parse(value),
				};

				config.Callback(value);
			end,

			Visible = function(self , Value)
				TextboxFrame.Visible = Value		
			end,

			Destroy = function(self)
				TextboxFrame:Destroy();		
			end,

			Signal = OnChange.Event:Connect(function(value)
				if value then
					task.wait(delayTick);

					Airflow:CreateAnimation(block,0.7,nil,{
						BackgroundTransparency = 0.500
					})

					Airflow:CreateAnimation(PText,0.7,nil,{
						TextTransparency = 0.3
					})

					Airflow:CreateAnimation(TextBox,0.7,nil,{
						TextTransparency = 0
					})

					Airflow:CreateAnimation(TextboxFrame,0.6,nil,{
						BackgroundTransparency = 0.800,
					})

				else
					Airflow:CreateAnimation(block,0.5,nil,{
						BackgroundTransparency = 1
					})

					Airflow:CreateAnimation(PText,0.5,nil,{
						TextTransparency = 1
					})

					Airflow:CreateAnimation(TextBox,0.5,nil,{
						TextTransparency = 1
					})

					Airflow:CreateAnimation(TextboxFrame,0.5,nil,{
						BackgroundTransparency = 1,
					})
				end
			end)
		};

		ElementIDs[ID] = {
			Name = config.Name,
			ID = ID,
			Type = "TextBox",
			API = tableback,
			IDCode = "TextBox_"..config.Name.."_"..tostring(ID),
		};

		return tableback
	end;

	function elements:AddColorPicker(config)
		config = config or {};
		config.Name = config.Name or "ColorPicker";
		config.Default = config.Default or Color3.fromRGB(255,255,255);
		config.Callback = config.Callback or function() end;

		local ID = ElementId;
		local ColorPickerFrame = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local PText = Instance.new("TextLabel")
		local block = Instance.new("Frame")
		local UICorner_2 = Instance.new("UICorner")
		local UIStroke = Instance.new("UIStroke")
		local TextButton = Instance.new("TextButton")

		ColorPickerFrame.Name = Airflow:RandomString()
		ColorPickerFrame.Parent = element;
		ColorPickerFrame.BackgroundColor3 = Color3.fromRGB(91, 91, 91)
		ColorPickerFrame.BackgroundTransparency = 1
		ColorPickerFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ColorPickerFrame.BorderSizePixel = 0
		ColorPickerFrame.Size = UDim2.new(1, -2, 0, 40)
		ColorPickerFrame.ZIndex = 6

		UICorner.CornerRadius = UDim.new(0, 4)
		UICorner.Parent = ColorPickerFrame

		PText.Name = Airflow:RandomString()
		PText.Parent = ColorPickerFrame
		PText.AnchorPoint = Vector2.new(0, 0.5)
		PText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		PText.BackgroundTransparency = 1.000
		PText.BorderColor3 = Color3.fromRGB(0, 0, 0)
		PText.BorderSizePixel = 0
		PText.Position = UDim2.new(0, 10, 0.5, 0)
		PText.Size = UDim2.new(1, 50, 0, 20)
		PText.ZIndex = 7
		PText.Font = Enum.Font.GothamMedium
		PText.Text = config.Name
		PText.TextColor3 = Color3.fromRGB(255, 255, 255)
		PText.TextSize = 13.000
		PText.TextTransparency = 1
		PText.TextWrapped = true

		PText.TextXAlignment = Enum.TextXAlignment.Left

		block.Name = Airflow:RandomString()
		block.Parent = ColorPickerFrame
		block.AnchorPoint = Vector2.new(1, 0.5)
		block.BackgroundColor3 = config.Default;
		block.BorderColor3 = Color3.fromRGB(0, 0, 0)
		block.BorderSizePixel = 0
		block.Position = UDim2.new(1, -10, 0.5, 0)
		block.Size = UDim2.new(0, 45, 0, 20)
		block.ZIndex = 7
		block.BackgroundTransparency = 1;

		UICorner_2.CornerRadius = UDim.new(0, 4)
		UICorner_2.Parent = block

		UIStroke.Transparency = 0.380
		UIStroke.Color = Color3.fromRGB(88, 88, 88)
		UIStroke.Parent = block

		TextButton.Parent = ColorPickerFrame
		TextButton.BackgroundTransparency = 1.000
		TextButton.Size = UDim2.new(1, 0, 1, 0)
		TextButton.ZIndex = 16
		TextButton.TextTransparency = 1.000

		if OnChange:GetAttribute('Value') then
			task.delay(0.5,Airflow.CreateAnimation,Airflow,block,0.5,nil,{
				BackgroundTransparency = 0
			})

			task.delay(0.5,Airflow.CreateAnimation,Airflow,PText,0.5,nil,{
				TextTransparency = 0.3
			})

			task.delay(0.4,Airflow.CreateAnimation,Airflow,ColorPickerFrame,0.5,nil,{
				BackgroundTransparency = 0.800,
			})
		end;

		local Detector = function(color)
			config.Default = color;

			local R,G,B = color.R * 255,color.G * 255,color.B * 255;

			Airflow:CreateAnimation(block,0.7,nil,{
				BackgroundColor3 = config.Default;
			});

			ElementConfigs["ColorPicker_"..config.Name.."_"..tostring(ID)] = {
				Value = {R,G,B},
			};

			config.Callback(color);
		end;


		do
			local R,G,B = config.Default.R * 255,config.Default.G * 255,config.Default.B * 255;

			ElementConfigs["ColorPicker_"..config.Name.."_"..tostring(ID)] = {
				Value = {R,G,B},
			};
		end;

		TextButton.MouseButton1Click:Connect(function()
			task.wait();
			Airflow.Features.ColorPickerToggle = not Airflow.Features.ColorPickerToggle;
			Airflow.Features:SetColor(config.Default);
			Airflow.Features:OnColorPicker(Airflow.Features.ColorPickerToggle);
			Airflow.Features:SetPosition(UDim2.fromOffset(block.AbsolutePosition.X,block.AbsolutePosition.Y));
			Airflow.Features.Callback = Detector;
		end)

		Airflow:Hover(ColorPickerFrame);

		ElementId += 1;

		local tableback = {
			Edit = function(self , Value)
				PText.Text = Value;
			end,

			SetValue = function(self , value)
				return Detector(value);
			end,

			Visible = function(self , Value)
				ColorPickerFrame.Visible = Value		
			end,

			Destroy = function(self)
				ColorPickerFrame:Destroy();		
			end,

			Signal = OnChange.Event:Connect(function(value)
				if value then
					task.wait(delayTick);

					Airflow:CreateAnimation(ColorPickerFrame,0.7,nil,{
						BackgroundTransparency = 0.800,
					})

					Airflow:CreateAnimation(PText,0.6,nil,{
						TextTransparency = 0.3
					})

					Airflow:CreateAnimation(block,0.7,nil,{
						BackgroundTransparency = 0,
						BackgroundColor3 = config.Default,
					})
				else
					Airflow:CreateAnimation(ColorPickerFrame,0.5,nil,{
						BackgroundTransparency = 1,
					})

					Airflow:CreateAnimation(PText,0.5,nil,{
						TextTransparency = 1
					})

					Airflow:CreateAnimation(block,0.5,nil,{
						BackgroundTransparency = 1,
						BackgroundColor3 = Color3.fromRGB(0,0,0),
					})
				end
			end)
		};

		ElementIDs[ID] = {
			Name = config.Name,
			ID = ID,
			Type = "ColorPicker",
			API = tableback,
			IDCode = "ColorPicker_"..config.Name.."_"..tostring(ID),
		};

		return tableback
	end;

	function elements:AddParagraph(config)
		config = config or {};
		config.Name = config.Name or "Paragraph";
		config.Content = config.Content or nil;

		local ID = ElementId;
		local ParagraphFrame = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local PText = Instance.new("TextLabel")
		local SText = Instance.new("TextLabel")

		ParagraphFrame.Name = Airflow:RandomString()
		ParagraphFrame.Parent = element
		ParagraphFrame.BackgroundColor3 = Color3.fromRGB(91, 91, 91)
		ParagraphFrame.BackgroundTransparency = 1
		ParagraphFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ParagraphFrame.BorderSizePixel = 0
		ParagraphFrame.ClipsDescendants = true
		ParagraphFrame.Size = UDim2.new(1, -2, 0, 45)
		ParagraphFrame.ZIndex = 6

		UICorner.CornerRadius = UDim.new(0, 4)
		UICorner.Parent = ParagraphFrame

		PText.Name = Airflow:RandomString()
		PText.Parent = ParagraphFrame
		PText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		PText.BackgroundTransparency = 1.000
		PText.BorderColor3 = Color3.fromRGB(0, 0, 0)
		PText.BorderSizePixel = 0
		PText.Position = UDim2.new(0, 10, 0, 4)
		PText.Size = UDim2.new(1, 50, 0, 20)
		PText.ZIndex = 7
		PText.Font = Enum.Font.GothamMedium
		PText.Text = config.Name
		PText.TextColor3 = Color3.fromRGB(255, 255, 255)
		PText.TextSize = 13.000
		PText.TextTransparency = 1
		PText.TextWrapped = true
		PText.TextXAlignment = Enum.TextXAlignment.Left

		SText.Name = Airflow:RandomString()
		SText.Parent = ParagraphFrame
		SText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		SText.BackgroundTransparency = 1.000
		SText.BorderColor3 = Color3.fromRGB(0, 0, 0)
		SText.BorderSizePixel = 0
		SText.Position = UDim2.new(0, 10, 0, 25)
		SText.Size = UDim2.new(1, 50, 1, -25)
		SText.ZIndex = 7
		SText.Font = Enum.Font.GothamMedium
		SText.Text = config.Content or "";
		SText.TextColor3 = Color3.fromRGB(255, 255, 255)
		SText.TextSize = 11.000
		SText.TextTransparency = 1
		SText.TextWrapped = true
		SText.TextXAlignment = Enum.TextXAlignment.Left
		SText.TextYAlignment = Enum.TextYAlignment.Top

		if OnChange:GetAttribute('Value') then
			task.delay(0.5,Airflow.CreateAnimation,Airflow,SText,0.5,nil,{
				TextTransparency = 0.300
			})

			task.delay(0.5,Airflow.CreateAnimation,Airflow,PText,0.5,nil,{
				TextTransparency = 0.200
			})

			task.delay(0.4,Airflow.CreateAnimation,Airflow,ParagraphFrame,0.5,nil,{
				BackgroundTransparency = 0.800,
			})
		end;

		Airflow:Hover(ParagraphFrame);

		local updateScale = function()

			if config.Content or SText.Text:Byte() then
				local SizeY = 27;

				local size = TextService:GetTextSize(SText.Text,SText.TextSize,SText.Font,Vector2.new(math.huge,math.huge));

				SizeY += size.Y;

				Airflow:CreateAnimation(ParagraphFrame,0.4,nil,{
					Size = UDim2.new(1, -2,0, SizeY + 10)
				});
			else
				Airflow:CreateAnimation(ParagraphFrame,0.4,nil,{
					Size = UDim2.new(1, -2,0, 27)
				});
			end;
		end;

		task.delay(0.4,updateScale)

		ElementId += 1;

		local tableback = {
			EditName = function(self , Value)
				PText.Text = Value;
				updateScale();
			end,

			EditContent = function(self , Value)
				SText.Text = Value;
				updateScale();
			end,

			Visible = function(self , Value)
				ParagraphFrame.Visible = Value		
			end,

			Destroy = function(self)
				ParagraphFrame:Destroy();		
			end,

			Signal = OnChange.Event:Connect(function(value)
				if value then
					task.wait(delayTick);

					Airflow:CreateAnimation(ParagraphFrame,0.7,nil,{
						BackgroundTransparency = 0.800,
					})

					Airflow:CreateAnimation(PText,0.6,nil,{
						TextTransparency = 0.200
					})

					Airflow:CreateAnimation(SText,0.7,nil,{
						TextTransparency = 0.300
					})
				else
					Airflow:CreateAnimation(ParagraphFrame,0.5,nil,{
						BackgroundTransparency = 1,
					})

					Airflow:CreateAnimation(PText,0.5,nil,{
						TextTransparency = 1
					})

					Airflow:CreateAnimation(SText,0.5,nil,{
						TextTransparency = 1
					})
				end
			end)
		};

		ElementIDs[ID] = {
			Name = config.Name,
			ID = ID,
			Type = "Paragraph",
			API = tableback,
			IDCode = "Paragraph_"..config.Name.."_"..tostring(ID),
		};

		return tableback;
	end;

	function elements:AddDropdown(config)
		config = config or {};
		config.Name = config.Name or "Dropdown";
		config.Values = config.Values or {};
		config.Default = config.Default or {};
		config.Multi = config.Multi or false;
		config.Callback = config.Callback or function() end;

		local parse = function(value)
			if not value then return 'NONE' end;

			local Out;

			if typeof(value) == 'table' then
				if #value > 0 then
					local x = {};

					for i,v in next , value do
						table.insert(x , tostring(v))
					end;

					Out = table.concat(x,' , ')
				else
					local x = {};

					for i,v in next , value do
						if v == true then

							table.insert(x , tostring(i))
						end			
					end;

					Out = table.concat(x,' , ')
				end;
			else
				Out = tostring(value);
			end;

			return Out;
		end;

		local ID = ElementId;
		local DropdownFrame = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local PText = Instance.new("TextLabel")
		local block = Instance.new("Frame")
		local UICorner_2 = Instance.new("UICorner")
		local VText = Instance.new("TextLabel")
		local ImageLabel = Instance.new("ImageLabel")
		local DropdownInner = Instance.new("Frame")
		local UICorner_3 = Instance.new("UICorner")
		local LineV = Instance.new("Frame")
		local ScrollingFrame = Instance.new("ScrollingFrame")
		local UIListLayout = Instance.new("UIListLayout")

		DropdownFrame.Name = Airflow:RandomString()
		DropdownFrame.Parent = element
		DropdownFrame.BackgroundColor3 = Color3.fromRGB(91, 91, 91)
		DropdownFrame.BackgroundTransparency = 1
		DropdownFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		DropdownFrame.BorderSizePixel = 0
		DropdownFrame.Size = UDim2.new(1, -6, 0, 25)
		DropdownFrame.ZIndex = 6

		UICorner.CornerRadius = UDim.new(0, 4)
		UICorner.Parent = DropdownFrame

		PText.Name = Airflow:RandomString()
		PText.Parent = DropdownFrame
		PText.AnchorPoint = Vector2.new(0, 0.5)
		PText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		PText.BackgroundTransparency = 1.000
		PText.BorderColor3 = Color3.fromRGB(0, 0, 0)
		PText.BorderSizePixel = 0
		PText.Position = UDim2.new(0, 10, 0.5, 0)
		PText.Size = UDim2.new(1, 50, 0, 20)
		PText.ZIndex = 7
		PText.Font = Enum.Font.GothamMedium
		PText.Text = config.Name
		PText.TextColor3 = Color3.fromRGB(255, 255, 255)
		PText.TextSize = 13.000
		PText.TextTransparency = 1
		PText.TextWrapped = true
		PText.TextXAlignment = Enum.TextXAlignment.Left


		block.Name = Airflow:RandomString()
		block.Parent = DropdownFrame
		block.AnchorPoint = Vector2.new(1, 0.5)
		block.BackgroundColor3 = Color3.fromRGB(40,40,38)
		block.BackgroundTransparency = 1.000
		block.BorderColor3 = Color3.fromRGB(0, 0, 0)
		block.BorderSizePixel = 0
		block.Position = UDim2.new(1, -10, 0.5, 0)
		block.Size = UDim2.new(0, 65, 0, 30)
		block.ZIndex = 7

		UICorner_2.CornerRadius = UDim.new(0, 2)
		UICorner_2.Parent = block

		VText.Name = Airflow:RandomString()
		VText.Parent = block
		VText.AnchorPoint = Vector2.new(0, 0.5)
		VText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		VText.BackgroundTransparency = 1.000
		VText.BorderColor3 = Color3.fromRGB(0, 0, 0)
		VText.BorderSizePixel = 0
		VText.Position = UDim2.new(0, 7, 0.5, 0)
		VText.Size = UDim2.new(1, -30, 0, 20)
		VText.ZIndex = 7
		VText.Font = Enum.Font.GothamMedium
		VText.Text = parse(config.Default)
		VText.TextColor3 = Color3.fromRGB(255, 255, 255)
		VText.TextSize = 14.000
		VText.TextWrapped = true
		VText.TextXAlignment = Enum.TextXAlignment.Left
		VText.TextTransparency = 1
		VText.TextTruncate = Enum.TextTruncate.SplitWord;

		ImageLabel.Parent = block
		ImageLabel.AnchorPoint = Vector2.new(1, 0.5)
		ImageLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ImageLabel.BackgroundTransparency = 1.000
		ImageLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ImageLabel.BorderSizePixel = 0
		ImageLabel.Position = UDim2.new(1, -6, 0.5, 0)
		ImageLabel.Size = UDim2.new(0.5, 0, 0.5, 0)
		ImageLabel.SizeConstraint = Enum.SizeConstraint.RelativeYY
		ImageLabel.ZIndex = 8
		ImageLabel.Image = "rbxassetid://10709790948"
		ImageLabel.ImageTransparency = 1

		DropdownInner.Name = Airflow:RandomString()
		DropdownInner.AnchorPoint = Vector2.new(0.5,0)
		DropdownInner.Parent = block
		DropdownInner.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
		DropdownInner.BackgroundTransparency = 0.025
		DropdownInner.BorderColor3 = Color3.fromRGB(0, 0, 0)
		DropdownInner.BorderSizePixel = 0
		DropdownInner.ClipsDescendants = true
		DropdownInner.Position = UDim2.new(0.5, 0, 1, 0)
		DropdownInner.Size = UDim2.new(1, 0, 0, 0)
		DropdownInner.ZIndex = 100
		DropdownInner.Rotation = 0;
		DropdownInner.Active = true

		UICorner_3.CornerRadius = UDim.new(0, 2)
		UICorner_3.Parent = DropdownInner

		LineV.Name = Airflow:RandomString()
		LineV.Parent = DropdownInner
		LineV.BackgroundColor3 = Color3.fromRGB(63, 63, 63)
		LineV.BackgroundTransparency = 0.500
		LineV.BorderColor3 = Color3.fromRGB(0, 0, 0)
		LineV.BorderSizePixel = 0
		LineV.Size = UDim2.new(1, 0, 0, 1)
		LineV.ZIndex = 101

		ScrollingFrame.Parent = DropdownInner
		ScrollingFrame.Active = true
		ScrollingFrame.AnchorPoint = Vector2.new(0.5, 0.5)
		ScrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ScrollingFrame.BackgroundTransparency = 1.000
		ScrollingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ScrollingFrame.BorderSizePixel = 0
		ScrollingFrame.ClipsDescendants = true
		ScrollingFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
		ScrollingFrame.Size = UDim2.new(1, -5, 1, -4)
		ScrollingFrame.ZIndex = 104
		ScrollingFrame.ScrollBarThickness = 0

		UIListLayout.Parent = ScrollingFrame
		UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center;
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.Padding = UDim.new(0, 6)

		if OnChange:GetAttribute('Value') then
			task.delay(0.5,Airflow.CreateAnimation,Airflow,ImageLabel,0.5,nil,{
				ImageTransparency = 0
			})


			task.delay(0.5,Airflow.CreateAnimation,Airflow,VText,0.5,nil,{
				TextTransparency = 0
			})

			task.delay(0.5,Airflow.CreateAnimation,Airflow,PText,0.5,nil,{
				TextTransparency = 0.300
			})

			task.delay(0.4,Airflow.CreateAnimation,Airflow,DropdownFrame,0.5,nil,{
				BackgroundTransparency = 0.800,
				Size = UDim2.new(1, -2, 0, 35)
			})
		end;

		UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function() 
			ScrollingFrame.CanvasSize = UDim2.fromOffset(0,UIListLayout.AbsoluteContentSize.Y + 2)
		end);

		local IsDefault = function(val)
			if typeof(config.Default) == 'table' then
				if table.find(config.Default,val) or config.Default[val] then
					return true;
				end;
			else
				if config.Default == val then
					return true
				end
			end;
		end;

		local scale = TextService:GetTextSize(VText.Text,VText.TextSize,VText.Font,Vector2.new(math.huge,math.huge));
		local LongestSize = scale.X;

		local refresh = function()
			for i,v in next,  ScrollingFrame:GetChildren() do
				if v:IsA('TextButton') then
					v:Destroy();
				end;
			end;

			if config.Multi then
				local SelectedItems = {};

				for i,v in next , config.Values do
					local InputButton = Instance.new("TextButton")

					InputButton.Name = Airflow:RandomString()
					InputButton.Parent = ScrollingFrame;
					InputButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					InputButton.BackgroundTransparency = 1.000
					InputButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
					InputButton.BorderSizePixel = 0
					InputButton.Size = UDim2.new(1, -3, 0, 20)
					InputButton.ZIndex = 105
					InputButton.Font = Enum.Font.GothamMedium
					InputButton.Text = string.rep(" ",2)..tostring(v)
					InputButton.TextColor3 = Color3.fromRGB(255, 255, 255)
					InputButton.TextSize = 14.000
					InputButton.TextTransparency = 0.5
					InputButton.TextXAlignment = Enum.TextXAlignment.Left

					if IsDefault(v) then
						InputButton.TextTransparency = 0;
						SelectedItems[v] = true;
					end;

					local scale = TextService:GetTextSize(InputButton.Text,InputButton.TextSize,InputButton.Font,Vector2.new(math.huge,math.huge));

					if scale.X > LongestSize then
						LongestSize = scale.X;
					end;

					InputButton.MouseButton1Click:Connect(function()
						SelectedItems[v] = not SelectedItems[v];

						if SelectedItems[v] then
							InputButton.TextTransparency = 0;
						else
							InputButton.TextTransparency = 0.5;
						end;

						config.Default = SelectedItems;
						VText.Text = parse(SelectedItems)

						ElementConfigs["Dropdown_"..config.Name.."_"..tostring(ID)] = {
							Value = SelectedItems,
						};

						config.Callback(SelectedItems)
					end)
				end;
			else
				local SelectedItem;
				for i,v in next , config.Values do
					local InputButton = Instance.new("TextButton")

					InputButton.Name = Airflow:RandomString()
					InputButton.Parent = ScrollingFrame;
					InputButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
					InputButton.BackgroundTransparency = 1.000
					InputButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
					InputButton.BorderSizePixel = 0
					InputButton.Size = UDim2.new(1,-3, 0, 15)
					InputButton.ZIndex = 105
					InputButton.Font = Enum.Font.GothamMedium
					InputButton.Text = string.rep(" ",2)..tostring(v)
					InputButton.TextColor3 = Color3.fromRGB(255, 255, 255)
					InputButton.TextSize = 14.000
					InputButton.TextTransparency = 0.5
					InputButton.TextXAlignment = Enum.TextXAlignment.Left


					if v == config.Default then
						InputButton.TextTransparency = 0;
						SelectedItem = InputButton;
					end;

					local scale = TextService:GetTextSize(InputButton.Text,InputButton.TextSize,InputButton.Font,Vector2.new(math.huge,math.huge));

					if scale.X > LongestSize then
						LongestSize = scale.X;
					end;

					InputButton.MouseButton1Click:Connect(function()
						if SelectedItem then
							SelectedItem.TextTransparency = 0.5;
						end;

						InputButton.TextTransparency = 0;
						SelectedItem = InputButton;

						VText.Text = parse(v)
						config.Default = v;

						ElementConfigs["Dropdown_"..config.Name.."_"..tostring(ID)] = {
							Value = v,
						};

						config.Callback(v)
					end)
				end;
			end;
		end;

		local UpdateValueText = function()
			local scale = TextService:GetTextSize(VText.Text,VText.TextSize,VText.Font,Vector2.new(math.huge,math.huge));

			Airflow:CreateAnimation(VText,0.65,nil,{
				Position = UDim2.new(0, 23, 0.5, 0),
				Size = UDim2.new(1, -45,0, 20)
			})
		end;

		ElementConfigs["Dropdown_"..config.Name.."_"..tostring(ID)] = {
			Value = config.Default,
		};

		refresh();

		local ToggleValue = false;

		local Change = function(Value)
			ToggleValue = Value;
			local scale = TextService:GetTextSize(VText.Text,VText.TextSize,VText.Font,Vector2.new(math.huge,math.huge));

			local NameScale = TextService:GetTextSize(PText.Text,PText.TextSize,PText.Font,Vector2.new(math.huge,math.huge));

			local MaxSize = (200 - NameScale.X) + DropdownFrame.AbsoluteSize.X / 10;

			if Value then
				local TargetScale = (scale.X > LongestSize and scale.X) or LongestSize;

				Airflow:CreateAnimation(block,0.35,nil,{
					BackgroundTransparency = 0.5,
					Size = UDim2.new(0, math.clamp((TargetScale + 15) + 37,75,MaxSize),0, 30)
				})

				Airflow:CreateAnimation(DropdownInner,0.5,nil,{
					Size = UDim2.new(0,math.clamp((TargetScale + 15) + 37,75,MaxSize),0,math.min(UIListLayout.AbsoluteContentSize.Y + 11,150))
				})

				Airflow:CreateAnimation(ScrollingFrame,0.5,nil,{
					Position = UDim2.new(0.5, 0, 0.5, 0)
				})

				Airflow:CreateAnimation(ImageLabel,0.4,nil,{
					Rotation = -180
				})

				Airflow:CreateAnimation(VText,0.65,nil,{
					Position = UDim2.new(0, 7, 0.5, 0),
					Size = UDim2.new(1, -30, 0, 20)
				})

				DropdownInner.Rotation = 0;
			else
				DropdownInner.Rotation = 0;

				Airflow:CreateAnimation(ScrollingFrame,0.5,nil,{
					Position = UDim2.new(0.65, 0, 0.5, 0)
				})

				Airflow:CreateAnimation(ImageLabel,0.4,nil,{
					Rotation = 0
				})

				Airflow:CreateAnimation(block,0.75,nil,{
					BackgroundTransparency = 1,
					Size = UDim2.new(0, math.clamp((scale.X + 15) + 37,75,MaxSize),0, 30)
				})

				Airflow:CreateAnimation(DropdownInner,0.4,nil,{
					Size = UDim2.new(0, math.clamp((scale.X + 15) + 37,75,MaxSize),0, 0)
				})

				UpdateValueText();
			end;
		end;

		UserInputService.InputBegan:Connect(function(sts)
			if sts.UserInputType == Enum.UserInputType.MouseButton1 or sts.UserInputType == Enum.UserInputType.Touch then
				if not Airflow:IsMouseOverFrame(DropdownFrame) and not Airflow:IsMouseOverFrame(DropdownInner) then
					Change(false)
				end;
			end
		end)

		Airflow:NewInput(DropdownFrame,function()
			refresh();

			ToggleValue = not ToggleValue;
			Change(ToggleValue)
		end);

		Airflow:Hover(DropdownFrame);

		Change(false);

		UpdateValueText();

		ElementId += 1;

		local tableback = {
			Edit = function(self , Value)
				PText.Text = Value;
			end,

			SetValues = function(self , Value)
				config.Values = Value;
			end,

			SetDefault = function(self , Value)
				config.Default = Value;
				VText.Text = parse(Value);

				ElementConfigs["Dropdown_"..config.Name.."_"..tostring(ID)] = {
					Value = Value,
				};

				Change(ToggleValue);

				config.Callback(Value)
			end,

			Visible = function(self , Value)
				DropdownFrame.Visible = Value		
			end,

			Destroy = function(self)
				DropdownFrame:Destroy();		
			end,

			Signal = OnChange.Event:Connect(function(value)
				if value then
					task.wait(delayTick);

					Airflow:CreateAnimation(DropdownFrame,0.7,nil,{
						BackgroundTransparency = 0.800,
						Size = UDim2.new(1, -2, 0, 35)
					})

					Airflow:CreateAnimation(PText,0.6,nil,{
						TextTransparency = 0.300
					})

					Airflow:CreateAnimation(VText,0.7,nil,{
						TextTransparency = 0
					})

					Airflow:CreateAnimation(ImageLabel,0.7,nil,{
						ImageTransparency = 0
					})
				else
					Airflow:CreateAnimation(DropdownFrame,0.5,nil,{
						BackgroundTransparency = 1,
						Size = UDim2.new(1, -6, 0, 35)
					})

					Airflow:CreateAnimation(PText,0.5,nil,{
						TextTransparency = 1
					})

					Airflow:CreateAnimation(VText,0.5,nil,{
						TextTransparency = 1
					})

					Airflow:CreateAnimation(ImageLabel,0.5,nil,{
						ImageTransparency = 1
					})
				end
			end)
		};

		ElementIDs[ID] = {
			Name = config.Name,
			ID = ID,
			Type = "Dropdown",
			API = tableback,
			IDCode = "Dropdown_"..config.Name.."_"..tostring(ID),
		};

		return tableback;
	end;

	function elements:GetElementFromKey(key)
		local _V = string.split(key,'_');

		local ID = _V[#_V];

		return ElementIDs[ID] or ElementIDs[tostring(ID)] or (function()
			for i,v in next , ElementIDs do
				if v.IDCode == key then
					return v;
				end;
			end;
		end)();
	end;

	function elements:GetConfigs()
		return ElementConfigs;
	end;

	function elements:GetElementFromId(id)
		return ElementIDs[id];
	end;

	function elements:GetInfo()
		return ElementIDs;
	end;

	return elements;
end;

function Airflow:Init(config)
	config = config or {};
	config.Name = config.Name or "airflow";
	config.Logo = config.Logo or Airflow.Config.Logo;
	config.Scale = config.Scale or Airflow.Config.Scale;
	config.Hightlight = config.Highlight or config.Hightlight or Airflow.Config.Hightlight;
	config.Keybind = config.Keybind or Airflow.Config.Keybind;
	config.Resizable = config.Resizable or Airflow.Config.Resizable;
	config.UnlockMouse = config.UnlockMouse or Airflow.Config.UnlockMouse;
	config.IconSize = config.IconSize or Airflow.Config.IconSize;
	config.Version = config.Version or "1.0";

	local Response = {
		TabElements = {};
		OpenedTab = nil;
		Toggle = true,
		Hightlight = config.Hightlight,
		FirstToggle = true;
		UnlockMouse = config.UnlockMouse;
		TabConfig = {};
	};

	local AirflowWindow = Instance.new("ScreenGui")
	local WindowFrame = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local MainFrame = Instance.new("Frame")
	local TabElements = Instance.new("Frame")
	local TabInputs = Instance.new("Frame")
	local ListInputs = Instance.new("ScrollingFrame")
	local UIListLayout = Instance.new("UIListLayout")
	local LineH = Instance.new("Frame")
	local LineV = Instance.new("Frame")
	local UIStroke = Instance.new("UIStroke")
	local UIGradient = Instance.new("UIGradient")
	local Headers = Instance.new("Frame")
	local UIListLayout_2 = Instance.new("UIListLayout")
	local Icon = Instance.new("ImageLabel")
	local UICorner_2 = Instance.new("UICorner")
	local windowName = Instance.new("TextLabel")
	local static = Instance.new("ImageLabel")

	WindowFrame:GetPropertyChangedSignal('BackgroundTransparency'):Connect(function()
		if WindowFrame.BackgroundTransparency < 0.9 then
			WindowFrame.Visible = true
		else
			WindowFrame.Visible = false
		end;
	end)

	local ToggleWindow = function(value)
		if value then
			if config.Resizable then
				Airflow:CreateAnimation(WindowFrame,0.5,nil,{
					Position = UDim2.new(0,WindowFrame.Position.X.Offset - 25,0,WindowFrame.Position.Y.Offset - 25)
				})
			end;

			Airflow:CreateAnimation(WindowFrame,0.5,nil,{
				Size = config.Scale;
				BackgroundTransparency = 0.600;
			})

			Airflow:CreateAnimation(MainFrame,0.45,nil,{
				BackgroundTransparency = 0.3;
			})

			Airflow:CreateAnimation(LineH,0.45,nil,{
				BackgroundTransparency = 0.5;
			})

			Airflow:CreateAnimation(LineV,0.45,nil,{
				BackgroundTransparency = 0.5;
			})

			Airflow:CreateAnimation(UIStroke,0.45,nil,{
				Transparency = 0.570;
			})

			Airflow:CreateAnimation(Icon,0.7,nil,{
				ImageTransparency = 0;
			})

			Airflow:CreateAnimation(static,0.45,nil,{
				ImageTransparency = 0.95;
			})

			Airflow:CreateAnimation(TabInputs,0.45,nil,{
				Position = UDim2.new(0,0,0,0)
			})

			Airflow:CreateAnimation(windowName,0.7,nil,{
				TextTransparency = 0.4;
			})

			if Response.OpenedTab then
				Response.OpenedTab(true)
			end;
		else
			for i,ChaValue in next,Response.TabElements do
				ChaValue(false);
			end;

			if config.Resizable then
				Airflow:CreateAnimation(WindowFrame,0.5,nil,{
					Position = UDim2.new(0,WindowFrame.Position.X.Offset + 25,0,WindowFrame.Position.Y.Offset + 25)
				})
			end;

			Airflow:CreateAnimation(WindowFrame,0.5,nil,{
				Size = UDim2.new(config.Scale.X.Scale,config.Scale.X.Offset - 50,config.Scale.Y.Scale,config.Scale.Y.Offset - 50);
				BackgroundTransparency = 1;
			})

			Airflow:CreateAnimation(MainFrame,0.45,nil,{
				BackgroundTransparency = 1;
			})

			Airflow:CreateAnimation(LineH,0.45,nil,{
				BackgroundTransparency = 1;
			})

			Airflow:CreateAnimation(LineV,0.45,nil,{
				BackgroundTransparency = 1;
			})

			Airflow:CreateAnimation(UIStroke,0.45,nil,{
				Transparency = 1;
			})

			Airflow:CreateAnimation(Icon,0.45,nil,{
				ImageTransparency = 1;
			})

			Airflow:CreateAnimation(static,0.45,nil,{
				ImageTransparency = 1;
			})

			Airflow:CreateAnimation(windowName,0.45,nil,{
				TextTransparency = 1;
			})

			Airflow:CreateAnimation(TabInputs,0.45,nil,{
				Position = UDim2.fromOffset(-155,0)
			})

			if Response.FirstToggle then
				Response.FirstToggle = false;
				Airflow:Notify({
					Title = "Keybind",
					Content = "press "..tostring(typeof(config.Keybind) == "string" and config.Keybind or config.Keybind.Name).." to open/close ui"
				})
			end
		end;
	end;

	task.delay(0.5,function()
		if Airflow.Features.ColorPickerRoot then
			Airflow.Features.ColorPickerRoot.Parent = AirflowWindow;
		end;
	end)

	AirflowWindow.Name = ".Airflow="..Airflow:RandomString()
	AirflowWindow.Parent = CoreGui;
	AirflowWindow.ResetOnSpawn = false
	AirflowWindow.IgnoreGuiInset = true;
	AirflowWindow.ZIndexBehavior = Enum.ZIndexBehavior.Global;

	protect_gui(AirflowWindow);
	Airflow:Blur(WindowFrame);

	WindowFrame.Active = true;
	WindowFrame.Name = Airflow:RandomString()
	WindowFrame.Parent = AirflowWindow
	WindowFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	WindowFrame.BackgroundColor3 = Color3.fromRGB(166, 166, 166)
	WindowFrame.BackgroundTransparency = 1
	WindowFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	WindowFrame.BorderSizePixel = 0
	WindowFrame.ClipsDescendants = true
	WindowFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	WindowFrame.Size = UDim2.new(config.Scale.X.Scale,config.Scale.X.Offset - 50,config.Scale.Y.Scale,config.Scale.Y.Offset - 50);

	UICorner.CornerRadius = UDim.new(0, 2)
	UICorner.Parent = WindowFrame

	MainFrame.Name = Airflow:RandomString()
	MainFrame.Parent = WindowFrame
	MainFrame.AnchorPoint = Vector2.new(0, 1)
	MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
	MainFrame.BackgroundTransparency = 1
	MainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	MainFrame.BorderSizePixel = 0
	MainFrame.ClipsDescendants = true
	MainFrame.Position = UDim2.new(0, 0, 1, 0)
	MainFrame.Size = UDim2.new(1, 0, 1, -40)
	MainFrame.ZIndex = 2

	TabElements.Name = Airflow:RandomString()
	TabElements.Parent = MainFrame
	TabElements.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TabElements.BackgroundTransparency = 1.000
	TabElements.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TabElements.BorderSizePixel = 0
	TabElements.Position = UDim2.new(0, 155, 0, 0)
	TabElements.Size = UDim2.new(1, -155, 1, 0)
	TabElements.ZIndex = 5

	TabInputs.Name = Airflow:RandomString()
	TabInputs.Parent = MainFrame
	TabInputs.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	TabInputs.BackgroundTransparency = 1.000
	TabInputs.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TabInputs.BorderSizePixel = 0
	TabInputs.ClipsDescendants = true
	TabInputs.Position = UDim2.fromOffset(-155,0)
	TabInputs.Size = UDim2.new(0, 155, 1, 0)
	TabInputs.ZIndex = 5

	ListInputs.Name = Airflow:RandomString()
	ListInputs.Parent = TabInputs
	ListInputs.Active = true
	ListInputs.AnchorPoint = Vector2.new(0.5, 0.5)
	ListInputs.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ListInputs.BackgroundTransparency = 1.000
	ListInputs.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ListInputs.BorderSizePixel = 0
	ListInputs.ClipsDescendants = false
	ListInputs.Position = UDim2.new(0.5, 0, 0.5, 0)
	ListInputs.Size = UDim2.new(1, -5, 1, -10)
	ListInputs.ZIndex = 6
	ListInputs.ScrollBarThickness = 0

	UIListLayout.Parent = ListInputs
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 5)

	UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
		ListInputs.CanvasSize = UDim2.fromOffset(0,UIListLayout.AbsoluteContentSize.Y + 5)
	end)

	LineH.Name = Airflow:RandomString()
	LineH.Parent = MainFrame
	LineH.BackgroundColor3 = Color3.fromRGB(63, 63, 63)
	LineH.BackgroundTransparency = 1
	LineH.BorderColor3 = Color3.fromRGB(0, 0, 0)
	LineH.BorderSizePixel = 0
	LineH.Position = UDim2.new(0, 155, 0, 0)
	LineH.Size = UDim2.new(0, 1, 1, 0)
	LineH.ZIndex = 5

	LineV.Name = Airflow:RandomString()
	LineV.Parent = MainFrame
	LineV.BackgroundColor3 = Color3.fromRGB(63, 63, 63)
	LineV.BackgroundTransparency = 1
	LineV.BorderColor3 = Color3.fromRGB(0, 0, 0)
	LineV.BorderSizePixel = 0
	LineV.Size = UDim2.new(1, 0, 0, 1)
	LineV.ZIndex = 5

	UIStroke.Transparency = 1
	UIStroke.Color = Color3.fromRGB(255, 255, 255)
	UIStroke.Parent = WindowFrame

	UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0, 0, 0)), ColorSequenceKeypoint.new(0.499, Color3.fromRGB(0, 0, 0)), ColorSequenceKeypoint.new(0.5, Color3.fromRGB(177, 177, 177)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(177, 177, 177))}
	UIGradient.Rotation = -90;
	UIGradient.Parent = UIStroke;
	UIGradient.Offset = Vector2.new(0,-((MainFrame.AbsoluteSize.Y / WindowFrame.AbsoluteSize.Y) / 2.15));

	MainFrame:GetPropertyChangedSignal('Size'):Connect(function()
		UIGradient.Offset = Vector2.new(0,-((MainFrame.AbsoluteSize.Y / WindowFrame.AbsoluteSize.Y) / 2.15));
	end);

	Headers.Name = Airflow:RandomString()
	Headers.Parent = WindowFrame
	Headers.AnchorPoint = Vector2.new(0.5, 0)
	Headers.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Headers.BackgroundTransparency = 1.000
	Headers.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Headers.BorderSizePixel = 0
	Headers.Position = UDim2.new(0.5, 0, 0, 5)
	Headers.Size = UDim2.new(1, -15, 0, 30)
	Headers.ZIndex = 3

	UIListLayout_2.Parent = Headers
	UIListLayout_2.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout_2.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout_2.VerticalAlignment = Enum.VerticalAlignment.Center
	UIListLayout_2.Padding = UDim.new(0, 3)

	Icon.Name = Airflow:RandomString()
	Icon.Parent = Headers
	Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Icon.BackgroundTransparency = 1.000
	Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Icon.BorderSizePixel = 0
	Icon.Size = UDim2.new(0, config.IconSize, 0, config.IconSize)
	Icon.ZIndex = 5
	Icon.Image = config.Logo;
	Icon.ImageTransparency = 1

	UICorner_2.CornerRadius = UDim.new(1, 0)
	UICorner_2.Parent = Icon

	windowName.Name = Airflow:RandomString()
	windowName.Parent = Headers
	windowName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	windowName.BackgroundTransparency = 1.000
	windowName.BorderColor3 = Color3.fromRGB(0, 0, 0)
	windowName.BorderSizePixel = 0
	windowName.Size = UDim2.new(0, 50, 0, 20)
	windowName.Font = Enum.Font.GothamMedium
	windowName.Text = config.Name;
	windowName.TextColor3 = Color3.fromRGB(255, 255, 255)
	windowName.TextSize = 15.000
	windowName.TextTransparency = 1

	static.Name = Airflow:RandomString()
	static.Parent = WindowFrame
	static.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	static.BackgroundTransparency = 1.000
	static.BorderColor3 = Color3.fromRGB(0, 0, 0)
	static.BorderSizePixel = 0
	static.Size = UDim2.new(1, 0, 1, 0)
	static.ZIndex = -10
	static.Image = "rbxassetid://9579075682"
	static.ImageTransparency = 1
	static.ScaleType = Enum.ScaleType.Crop

	function Response:Update()
		local WindowNameSize = TextService:GetTextSize(windowName.Text,windowName.TextSize,windowName.Font,Vector2.new(math.huge,math.huge));

		windowName.Size = UDim2.new(0, WindowNameSize.X + 4, 0, 20)
	end;

	function Response:GetTabFromKey(key)
		for i,v in next , Response.TabConfig do
			if (v.Name.."_"..tostring(v.ID)) == key then
				return v;
			end;
		end;
	end;

	function Response:GetConfigs()
		local process = {};

		for i,v in next , Response.TabConfig do
			process[v.Name.."_"..tostring(v.ID)] = v:GetConfigs();
		end;

		process.VERSION = config.Version;

		return process;
	end;

	function Response:DrawTab(config) : Tab
		config = config or {};
		config.Name = config.Name or "Tab";
		config.Icon = config.Icon or "book";

		-- Button --
		local InputElement = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local Icon = Instance.new("ImageLabel")
		local UICorner_2 = Instance.new("UICorner")
		local PText = Instance.new("TextLabel")
		local hightlight = Instance.new("Frame")

		InputElement.Name = Airflow:RandomString()
		InputElement.Parent = ListInputs;
		InputElement.BackgroundColor3 = Color3.fromRGB(91, 91, 91)
		InputElement.BackgroundTransparency = 1
		InputElement.BorderColor3 = Color3.fromRGB(0, 0, 0)
		InputElement.BorderSizePixel = 0
		InputElement.ClipsDescendants = true
		InputElement.Size = UDim2.new(1, 0, 0, 40)
		InputElement.ZIndex = 6

		UICorner.CornerRadius = UDim.new(0, 4)
		UICorner.Parent = InputElement

		Icon.Name = Airflow:RandomString()
		Icon.Parent = InputElement
		Icon.AnchorPoint = Vector2.new(0, 0.5)
		Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Icon.BackgroundTransparency = 1.000
		Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Icon.BorderSizePixel = 0
		Icon.Position = UDim2.new(0, 5, 0.5, 0)
		Icon.Size = UDim2.new(0, 19, 0, 19)
		Icon.ZIndex = 7
		Icon.Image = Airflow:GetIcon(config.Icon);

		UICorner_2.CornerRadius = UDim.new(1, 0)
		UICorner_2.Parent = Icon

		PText.Name = Airflow:RandomString()
		PText.Parent = InputElement
		PText.AnchorPoint = Vector2.new(0, 0.5)
		PText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		PText.BackgroundTransparency = 1.000
		PText.BorderColor3 = Color3.fromRGB(0, 0, 0)
		PText.BorderSizePixel = 0
		PText.Position = UDim2.new(0, 30, 0.5, 0)
		PText.Size = UDim2.new(1, 50, 0, 20)
		PText.ZIndex = 7
		PText.Font = Enum.Font.GothamMedium
		PText.Text = config.Name;
		PText.TextColor3 = Color3.fromRGB(255, 255, 255)
		PText.TextSize = 13.000
		PText.TextWrapped = true
		PText.TextXAlignment = Enum.TextXAlignment.Left

		hightlight.Name = Airflow:RandomString()
		hightlight.Parent = InputElement
		hightlight.AnchorPoint = Vector2.new(1, 0.5)
		hightlight.BackgroundColor3 = Response.Hightlight
		hightlight.BorderColor3 = Color3.fromRGB(0, 0, 0)
		hightlight.BorderSizePixel = 0
		hightlight.Position = UDim2.new(1, 0, 0.5, 0)
		hightlight.Size = UDim2.new(0, 2, 1, 0)
		hightlight.ZIndex = 8

		-- Main Frame --
		local ListElemants = Instance.new("Frame")
		local ListLeft = Instance.new("ScrollingFrame")
		local UIListLayout = Instance.new("UIListLayout")
		local ListRight = Instance.new("ScrollingFrame")
		local UIListLayout_2 = Instance.new("UIListLayout")

		ListElemants.Name = Airflow:RandomString()
		ListElemants.Parent = TabElements;
		ListElemants.AnchorPoint = Vector2.new(0.5, 0.5)
		ListElemants.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ListElemants.BackgroundTransparency = 1.000
		ListElemants.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ListElemants.BorderSizePixel = 0
		ListElemants.Position = UDim2.new(0.5, 0, 0.5, 0)
		ListElemants.Size = UDim2.new(1, -5, 1, -8)
		ListElemants.ZIndex = 6

		ListLeft.Name = Airflow:RandomString()
		ListLeft.Parent = ListElemants
		ListLeft.Active = true
		ListLeft.AnchorPoint = Vector2.new(0.5, 0.5)
		ListLeft.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ListLeft.BackgroundTransparency = 1.000
		ListLeft.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ListLeft.BorderSizePixel = 0
		ListLeft.ClipsDescendants = false
		ListLeft.Position = UDim2.new(0.25, 0, 0.5, 0)
		ListLeft.Size = UDim2.new(0.5, -5, 1, -8)
		ListLeft.ZIndex = 6
		ListLeft.ScrollBarThickness = 0

		UIListLayout.Parent = ListLeft
		UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.Padding = UDim.new(0, 5)
		UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
			ListLeft.CanvasSize = UDim2.fromOffset(0,UIListLayout.AbsoluteContentSize.Y + 5)
		end)

		ListRight.Name = Airflow:RandomString()
		ListRight.Parent = ListElemants
		ListRight.Active = true
		ListRight.AnchorPoint = Vector2.new(0.5, 0.5)
		ListRight.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ListRight.BackgroundTransparency = 1.000
		ListRight.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ListRight.BorderSizePixel = 0
		ListRight.ClipsDescendants = false
		ListRight.Position = UDim2.new(0.75, 0, 0.5, 0)
		ListRight.Size = UDim2.new(0.5, -5, 1, -8)
		ListRight.ZIndex = 6
		ListRight.ScrollBarThickness = 0

		UIListLayout_2.Parent = ListRight
		UIListLayout_2.HorizontalAlignment = Enum.HorizontalAlignment.Center
		UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout_2.Padding = UDim.new(0, 5)
		UIListLayout_2:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
			ListRight.CanvasSize = UDim2.fromOffset(0,UIListLayout_2.AbsoluteContentSize.Y + 5)
		end)

		ListElemants:GetPropertyChangedSignal('Position'):Connect(function()
			if ListElemants.Position.Y.Scale >= 0.6 then
				ListElemants.Visible = false;
			else
				ListElemants.Visible = true;
			end;
		end)

		local DisabledText = Instance.new("TextLabel")

		DisabledText.Parent = ListElemants
		DisabledText.AnchorPoint = Vector2.new(0.5, 0.5)
		DisabledText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		DisabledText.BackgroundTransparency = 1.000
		DisabledText.BorderColor3 = Color3.fromRGB(0, 0, 0)
		DisabledText.BorderSizePixel = 0
		DisabledText.Position = UDim2.new(0.5, 0, 0.5, 0)
		DisabledText.Size = UDim2.new(1, 0, 1, 0)
		DisabledText.ZIndex = 5
		DisabledText.Font = Enum.Font.GothamMedium
		DisabledText.Text = ""
		DisabledText.TextColor3 = Color3.fromRGB(255, 255, 255)
		DisabledText.TextSize = 15.000
		DisabledText.TextTransparency = 1
		DisabledText.TextWrapped = true

		-- Interface --

		local Bindable = Instance.new('BindableEvent',InputElement);

		local LeftElements = Airflow:Elements(ListLeft,Bindable,Response,"Section_"..config.Name.."_"..config.Name.."_"..tostring(#Response.TabElements).."_LEFT");
		local RightElements = Airflow:Elements(ListLeft,Bindable,Response,"Section_"..config.Name.."_"..config.Name.."_"..tostring(#Response.TabElements).."_RIGHT");
		local TabTable = {
			Left = LeftElements,
			Right = RightElements,
			Disabled = false,
			Name = config.Name,
			Sections = {},
			ID = #Response.TabElements,
		};

		local ElementId = 1;

		local ChangeValue = function(value)
			if TabTable.Disabled then
				ListLeft.Visible = false;
				ListRight.Visible = false;
			else
				ListLeft.Visible = true;
				ListRight.Visible = true;
			end;

			if value then

				Airflow:CreateAnimation(hightlight,0.4,nil,{
					BackgroundTransparency = 0
				});

				Airflow:CreateAnimation(InputElement,0.4,nil,{
					BackgroundTransparency = 0.8
				});

				Airflow:CreateAnimation(PText,0.4,nil,{
					TextTransparency = 0
				});

				Airflow:CreateAnimation(Icon,0.4,nil,{
					ImageTransparency = 0
				});

				Airflow:CreateAnimation(ListElemants,0.35,nil,{
					Position = UDim2.new(0.5, 0, 0.5, 0)
				})

				if Bindable:GetAttribute('Value') ~= value and not TabTable.Disabled then
					Bindable:Fire(true);
					Bindable:SetAttribute('Value',value);
				end;

				if TabTable.Disabled then
					Airflow:CreateAnimation(DisabledText,0.5,nil,{
						TextTransparency = 0.75
					})
				end;
			else
				if Bindable:GetAttribute('Value') ~= value and not TabTable.Disabled then
					Bindable:Fire(false);
					Bindable:SetAttribute('Value',value)
				end;

				if TabTable.Disabled then
					Airflow:CreateAnimation(DisabledText,0.35,nil,{
						TextTransparency = 1
					})
				end;

				Airflow:CreateAnimation(ListElemants,0.35,nil,{
					Position = UDim2.new(0.5, 0, 0.65, 0)
				})

				Airflow:CreateAnimation(InputElement,0.4,nil,{
					BackgroundTransparency = 1
				});

				Airflow:CreateAnimation(hightlight,0.4,nil,{
					BackgroundTransparency = 1
				});

				Airflow:CreateAnimation(PText,0.4,nil,{
					TextTransparency = 0.3
				});

				Airflow:CreateAnimation(Icon,0.4,nil,{
					ImageTransparency = 0.3
				});
			end;
		end;

		if not Response.TabElements[1] then
			Response.OpenedTab = ChangeValue;
			ChangeValue(true);
		else
			ChangeValue(false);
			ListElemants.Visible = false;
			task.delay(0.5,Bindable.Fire,Bindable,false)
		end;

		InputElement.MouseEnter:Connect(function()
			if Response.OpenedTab ~= ChangeValue then
				Airflow:CreateAnimation(InputElement,0.4,nil,{
					BackgroundTransparency = 0.85
				});
			else
				Airflow:CreateAnimation(InputElement,0.4,nil,{
					BackgroundTransparency = 0.8
				});
			end;
		end);

		InputElement.MouseLeave:Connect(function()
			if Response.OpenedTab ~= ChangeValue then
				Airflow:CreateAnimation(InputElement,0.4,nil,{
					BackgroundTransparency = 1
				});
			else
				Airflow:CreateAnimation(InputElement,0.4,nil,{
					BackgroundTransparency = 0.8
				});
			end;
		end);

		table.insert(Response.TabElements,ChangeValue);

		local Button = Airflow:NewInput(InputElement,function()
			for i,ChaValue in next,Response.TabElements do
				if ChaValue == ChangeValue then
					Response.OpenedTab = ChaValue;
					ChaValue(true);
				else
					ChaValue(false);
				end;
			end;
		end);

		Button.Modal = Response.UnlockMouse;

		function TabTable:Disable(value,reason)
			TabTable.Disabled = value;
			DisabledText.Text = tostring(reason or "");
		end;

		function TabTable:AddSection(config)
			config = config or {};
			config.Name = config.Name or "Section";
			config.Position = config.Position or "left";

			local Section = Instance.new("Frame")
			local LabelFrame = Instance.new("TextLabel")
			local UIListLayout = Instance.new("UIListLayout")

			Section.Name = Airflow:RandomString()
			Section.Parent = (string.lower(config.Position) == "left" and ListLeft) or ListRight;
			Section.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			Section.BackgroundTransparency = 1.000
			Section.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Section.BorderSizePixel = 0
			Section.ClipsDescendants = true
			Section.Size = UDim2.new(1, 0, 0, 150)

			LabelFrame.Name = Airflow:RandomString()
			LabelFrame.Parent = Section
			LabelFrame.AnchorPoint = Vector2.new(0, 0.5)
			LabelFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			LabelFrame.BackgroundTransparency = 1.000
			LabelFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
			LabelFrame.BorderSizePixel = 0
			LabelFrame.Position = UDim2.new(0, 30, 0.5, 0)
			LabelFrame.Size = UDim2.new(1, -10, 0, 17)
			LabelFrame.ZIndex = 7
			LabelFrame.Font = Enum.Font.GothamMedium
			LabelFrame.Text = config.Name
			LabelFrame.TextColor3 = Color3.fromRGB(255, 255, 255)
			LabelFrame.TextSize = 13.000
			LabelFrame.TextWrapped = true
			LabelFrame.TextXAlignment = Enum.TextXAlignment.Left

			UIListLayout.Parent = Section
			UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
			UIListLayout.Padding = UDim.new(0, 5)

			Bindable.Event:Connect(function(value)
				if value then
					task.wait(0.1);

					Airflow:CreateAnimation(LabelFrame,1.2,nil,{
						TextTransparency = 0;
					})
				else
					Airflow:CreateAnimation(LabelFrame,0.5,nil,{
						TextTransparency = 1;
					})
				end
			end)

			UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
				Airflow:CreateAnimation(Section,0.4,Enum.EasingStyle.Quint,{
					Size = UDim2.new(1, 0, 0, UIListLayout.AbsoluteContentSize.Y + 4)
				});
			end);

			Section:GetPropertyChangedSignal("AbsoluteSize"):Connect(function()
				if Section.Size.Y.Offset >= UIListLayout.AbsoluteContentSize.Y then
					Section.ClipsDescendants = false;
				else
					Section.ClipsDescendants = true;
				end;
			end);

			local ID = "Section_"..config.Name.."_"..TabTable.Name.."_"..tostring(#Response.TabElements).."_"..tostring(ElementId);
			local SectionElements = Airflow:Elements(Section,Bindable,Response,ID);

			ElementId += 1;

			table.insert(TabTable.Sections,{
				Elements = SectionElements,
				ID = ID,
			})

			return SectionElements;
		end;

		function TabTable:GetSectionFromKey(idx)
			local codeX = string.split(idx,"_");
			local ID = codeX[#codeX];

			for i,v in next , TabTable.Sections do
				if v.ID == ID or tostring(v.ID) == tostring(ID) or v.ID == idx then
					return v.Elements;
				end;
			end;
		end;

		function TabTable:GetSectionFromId(idx)
			for i,v in next , TabTable.Sections do
				if v.ID == idx or tostring(v.ID) == tostring(idx) then
					return v.Elements;
				end;
			end;
		end;

		function TabTable:GetConfigs()
			local sections = {};

			for i,v in next , TabTable.Sections do
				sections[v.ID] = v.Elements:GetConfigs();
			end;

			return {
				Left = LeftElements:GetConfigs(),
				Right = RightElements:GetConfigs(),
				Sections = sections,
			};
		end;

		table.insert(Response.TabConfig,TabTable);

		return TabTable;
	end;

	local dragToggle = nil;
	local dragSpeed = 0.25;
	local dragStart = nil;
	local startPos = nil;

	local function updateInput(input)
		local delta = input.Position - dragStart;

		local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y);

		Airflow:CreateAnimation(WindowFrame,dragSpeed,nil,{
			Position = position
		});
	end;

	Headers.InputBegan:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then 
			dragToggle = true
			dragStart = input.Position
			startPos = WindowFrame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragToggle = false
				end
			end)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			if dragToggle then
				updateInput(input)
			end
		end
	end);

	UserInputService.InputBegan:Connect(function(input,IsType)
		if (input.KeyCode.Name == config.Keybind or input.KeyCode == config.Keybind) and not IsType then
			Response.Toggle = not Response.Toggle;

			ToggleWindow(Response.Toggle);
		end;
	end);

	function Response:SetKeybind(new)
		config.Keybind = new;
	end;

	function Response:GetButton()
		local backpack = Instance.new("ImageButton")
		local UICorner = Instance.new("UICorner")
		local RowLabel = Instance.new("Frame")
		local UIListLayout = Instance.new("UIListLayout")
		local StyledTextLabel = Instance.new("TextLabel")
		local UITextSizeConstraint = Instance.new("UITextSizeConstraint")
		local UIPadding = Instance.new("UIPadding")
		local IconHost = Instance.new("Frame")
		local IntegrationIconFrame = Instance.new("Frame")
		local UIListLayout_2 = Instance.new("UIListLayout")
		local IntegrationIcon = Instance.new("ImageLabel")
		local SelectedHighlighter = Instance.new("Frame")
		local corner = Instance.new("UICorner")
		local Highlighter = Instance.new("Frame")
		local corner_2 = Instance.new("UICorner")
		local _5 = Instance.new("Frame")

		backpack.Name = "airflow";
		backpack.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
		backpack.BackgroundTransparency = 1.000
		backpack.BorderSizePixel = 0
		backpack.LayoutOrder = 9
		backpack.Size = UDim2.new(1, 0, 0, 56)
		backpack.AutoButtonColor = false

		UICorner.CornerRadius = UDim.new(0, 10)
		UICorner.Parent = backpack

		RowLabel.Name = "RowLabel"
		RowLabel.Parent = backpack
		RowLabel.BackgroundTransparency = 1.000
		RowLabel.BorderSizePixel = 0
		RowLabel.LayoutOrder = 9
		RowLabel.Size = UDim2.new(1, 0, 1, 0)

		UIListLayout.Parent = RowLabel
		UIListLayout.FillDirection = Enum.FillDirection.Horizontal
		UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
		UIListLayout.Padding = UDim.new(0, 8)

		StyledTextLabel.Name = "StyledTextLabel"
		StyledTextLabel.Parent = RowLabel
		StyledTextLabel.BackgroundTransparency = 1.000
		StyledTextLabel.Size = UDim2.new(1, -52, 1, 0)
		StyledTextLabel.Font = Enum.Font.BuilderSansBold
		StyledTextLabel.Text = config.Name
		StyledTextLabel.TextColor3 = Color3.fromRGB(247, 247, 248)
		StyledTextLabel.TextScaled = true
		StyledTextLabel.TextSize = 20.000
		StyledTextLabel.TextWrapped = true
		StyledTextLabel.TextXAlignment = Enum.TextXAlignment.Left

		UITextSizeConstraint.Parent = StyledTextLabel
		UITextSizeConstraint.MaxTextSize = 20
		UITextSizeConstraint.MinTextSize = 15

		UIPadding.Parent = RowLabel
		UIPadding.PaddingLeft = UDim.new(0, 8)
		UIPadding.PaddingRight = UDim.new(0, 8)

		IconHost.Name = "IconHost"
		IconHost.Parent = RowLabel
		IconHost.BackgroundTransparency = 1.000
		IconHost.BorderSizePixel = 0
		IconHost.LayoutOrder = 9
		IconHost.Size = UDim2.new(0, 44, 0, 44)
		IconHost.ZIndex = 9

		IntegrationIconFrame.Name = "IntegrationIconFrame"
		IntegrationIconFrame.Parent = IconHost
		IntegrationIconFrame.BackgroundTransparency = 1.000
		IntegrationIconFrame.BorderSizePixel = 0
		IntegrationIconFrame.Size = UDim2.new(1, 0, 1, 0)

		UIListLayout_2.Parent = IntegrationIconFrame
		UIListLayout_2.FillDirection = Enum.FillDirection.Horizontal
		UIListLayout_2.HorizontalAlignment = Enum.HorizontalAlignment.Center
		UIListLayout_2.VerticalAlignment = Enum.VerticalAlignment.Center

		IntegrationIcon.Name = "IntegrationIcon"
		IntegrationIcon.Parent = IntegrationIconFrame
		IntegrationIcon.BackgroundTransparency = 1.000
		IntegrationIcon.Size = UDim2.new(0, 36, 0, 36)
		IntegrationIcon.Image = config.Logo
		IntegrationIcon.ImageColor3 = Color3.fromRGB(247, 247, 248)

		SelectedHighlighter.Name = "SelectedHighlighter"
		SelectedHighlighter.Parent = IconHost
		SelectedHighlighter.AnchorPoint = Vector2.new(0.5, 0.5)
		SelectedHighlighter.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		SelectedHighlighter.BackgroundTransparency = 0.850
		SelectedHighlighter.BorderSizePixel = 0
		SelectedHighlighter.Position = UDim2.new(0.5, 0, 0.5, 0)
		SelectedHighlighter.Size = UDim2.new(0, 36, 0, 36)
		SelectedHighlighter.Visible = false

		corner.CornerRadius = UDim.new(1, 0)
		corner.Name = "corner"
		corner.Parent = SelectedHighlighter

		Highlighter.Name = "Highlighter"
		Highlighter.Parent = IconHost
		Highlighter.AnchorPoint = Vector2.new(0.5, 0.5)
		Highlighter.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Highlighter.BackgroundTransparency = 0.850
		Highlighter.BorderSizePixel = 0
		Highlighter.Position = UDim2.new(0.5, 0, 0.5, 0)
		Highlighter.Size = UDim2.new(0, 36, 0, 36)
		Highlighter.Visible = false

		corner_2.CornerRadius = UDim.new(1, 0)
		corner_2.Name = "corner"
		corner_2.Parent = Highlighter

		_5.Name = "5"
		_5.Parent = IconHost
		_5.BackgroundTransparency = 1.000
		_5.Size = UDim2.new(1, 0, 1, 0)
		_5.ZIndex = 2

		backpack.MouseButton1Click:Connect(function()
			Response.Toggle = not Response.Toggle;

			ToggleWindow(Response.Toggle)
		end);

		backpack.MouseEnter:Connect(function()
			Airflow:CreateAnimation(backpack,0.3,nil,{
				BackgroundColor3 = config.Hightlight,
				BackgroundTransparency = 0.85
			})
		end)

		backpack.MouseLeave:Connect(function()
			Airflow:CreateAnimation(backpack,0.3,nil,{
				BackgroundTransparency = 1
			})
		end)

		return backpack;
	end;

	local CreateResizable = function()
		Airflow:CreateAnimation(WindowFrame,0.5,nil,{
			AnchorPoint = Vector2.zero;
			Position = UDim2.new(0, (AirflowUI.AbsoluteSize.X / 2) - (WindowFrame.Size.X.Offset / 1.5), 0, (AirflowUI.AbsoluteSize.Y / 2) - (WindowFrame.Size.Y.Offset / 1.5))
		})

		local Resize = Instance.new("TextButton")
		local IsHold = false;

		Resize.Name = Airflow:RandomString();
		Resize.Parent = WindowFrame
		Resize.AnchorPoint = Vector2.new(0.5, 0.5)
		Resize.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Resize.BackgroundTransparency = 1.000
		Resize.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Resize.BorderSizePixel = 0
		Resize.Position = UDim2.new(1, 0, 1, 0)
		Resize.Rotation = 0.010
		Resize.Size = UDim2.new(0.075000003, 0, 0.075000003, 0)
		Resize.SizeConstraint = Enum.SizeConstraint.RelativeYY
		Resize.ZIndex = 100
		Resize.Font = Enum.Font.SourceSans
		Resize.Text = ""
		Resize.TextColor3 = Color3.fromRGB(0, 0, 0)
		Resize.TextSize = 14.000
		Resize.Active = true

		Resize.InputBegan:Connect(function(std)
			if std.UserInputType == Enum.UserInputType.MouseButton1 or std.UserInputType == Enum.UserInputType.Touch then
				IsHold = true
				if UserInputService.TouchEnabled then
					Resize.Size = UDim2.new(0.15, 85, 0.15, 85)
				end
			end
		end)

		Resize.InputEnded:Connect(function(std)
			if std.UserInputType == Enum.UserInputType.MouseButton1 or std.UserInputType == Enum.UserInputType.Touch then
				IsHold = false
				Resize.Size = UDim2.new(0.075, 0, 0.075, 0)
			end
		end)

		UserInputService.InputChanged:Connect(function(input)
			if IsHold and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) and Response.Toggle then
				local pios = input.Position;

				local x = (pios.X - WindowFrame.AbsolutePosition.X) 

				local y = (pios.Y - WindowFrame.AbsolutePosition.Y) 

				if x < 483 then x = 483 end
				if y < 297 then y = 297 end

				local Offset = UDim2.new(0,x,0,y)
				local plus = UDim2.fromOffset(-(WindowFrame.AbsoluteSize.X - x) / 2, -(WindowFrame.AbsoluteSize.Y - y) / 2);

				TweenService:Create(WindowFrame , TweenInfo.new(0.05),{
					Size = Offset,
				}):Play();

				config.Scale = Offset;
			end;
		end);

		function Response:SetResizable(value)
			if value then
				Resize.Visible = true
			else
				Resize.Visible = false
			end;
		end;
	end;

	if config.Resizable then
		CreateResizable();

	else
		function Response:SetResizable(value)
			if value then
				config.Resizable = true;
				CreateResizable();
			end;
		end;
	end;

	if Airflow:IsMobile() then
		Airflow:Notify({
			Title = "Mobile",
			Content = "Open roblox options to open/close menu"
		});
	end;

	-- Toggle Button --
	task.spawn(function()
		local IsExploit = pcall(function() 
			return game:GetService('CoreGui'):FindFirstChild('TopBarApp');
		end);

		local TopBar;
		if not IsExploit then
			TopBar = game:GetService('ReplicatedStorage'):FindFirstChild('Icon') or (game:GetService('ReplicatedStorage'):FindFirstChild('Elements',true) and game:GetService('ReplicatedStorage'):FindFirstChild('Elements',true).Parent);
			if TopBar then
				TopBar = require(TopBar);
				TopBar.new()
					:setImage(config.Logo)
					:setLabel(config.Name).toggled:Connect(function(val)
						Response.Toggle = not Response.Toggle;

						ToggleWindow(Response.Toggle)
					end)

				return;
			end;
		end;

		while true do task.wait(0.1)
			if IsExploit then
				local SubMenuHost = game:GetService('CoreGui'):FindFirstChild('TopBarApp'):FindFirstChild('TopBarApp'):FindFirstChild('UnibarLeftFrame'):FindFirstChild('UnibarMenu'):WaitForChild('SubMenuHost');

				if SubMenuHost:FindFirstChild('nine_dot') then
					local ScrollingFrame : ScrollingFrame = SubMenuHost:FindFirstChild('nine_dot'):FindFirstChild('ScrollingFrame'):FindFirstChild('MainCanvas');

					if not ScrollingFrame:FindFirstChild('airflow') then
						local airflow = Response:GetButton();

						airflow.Parent = ScrollingFrame;
					else
						local UISizeConstraint : UISizeConstraint = ScrollingFrame:FindFirstChild('UISizeConstraint');
						local UIListLayout : UIListLayout = ScrollingFrame:FindFirstChild('UIListLayout');
						local BottomPadding : Frame = ScrollingFrame:FindFirstChild('BottomPadding');

						if UserInputService.TouchEnabled then
							ScrollingFrame.CanvasSize = UDim2.fromOffset(0,UIListLayout.AbsoluteContentSize.Y);
						else
							UISizeConstraint.MinSize = Vector2.new(0,UIListLayout.AbsoluteContentSize.Y - BottomPadding.AbsoluteSize.Y);
						end;
					end;
				end;
			end;
		end;
	end)

	ToggleWindow(true);

	Response:Update();

	return Response;
end;

function Airflow:DrawList(config)
	config = config or {};
	config.Icon = config.Icon or "keyboard";
	config.Name = config.Name or "keybinds";

	local Response = {
		Toggle = true;
	};

	local AirflowUI = Instance.new("ScreenGui")
	local ListFrame = Instance.new("Frame")
	local UICorner = Instance.new("UICorner")
	local MainFrame = Instance.new("Frame")
	local LineV = Instance.new("Frame")
	local UIListLayout = Instance.new("UIListLayout")
	local UIStroke = Instance.new("UIStroke")
	local Headers = Instance.new("Frame")
	local UIListLayout_2 = Instance.new("UIListLayout")
	local Icon = Instance.new("ImageLabel")
	local UICorner_2 = Instance.new("UICorner")
	local WindowName = Instance.new("TextLabel")
	local static = Instance.new("ImageLabel")

	local ToggleFun = function(value)
		if value then
			Airflow:CreateAnimation(ListFrame,0.3,nil,{
				BackgroundTransparency = 0.600
			});

			Airflow:CreateAnimation(MainFrame,0.3,nil,{
				BackgroundTransparency = 0.3
			});

			Airflow:CreateAnimation(LineV,0.3,nil,{
				BackgroundTransparency = 0.500
			});

			Airflow:CreateAnimation(LineV,0.3,nil,{
				BackgroundTransparency = 0.500
			});

			Airflow:CreateAnimation(UIStroke,0.3,nil,{
				Transparency = 0.570
			});

			Airflow:CreateAnimation(Icon,0.3,nil,{
				ImageTransparency = 0
			});

			Airflow:CreateAnimation(WindowName,0.3,nil,{
				TextTransparency = 0.4
			});

			Airflow:CreateAnimation(static,0.3,nil,{
				ImageTransparency = 0.9
			});

			Airflow:CreateAnimation(ListFrame,0.3,nil,{
				Size = UDim2.new(0, 200, 0, UIListLayout.AbsoluteContentSize.Y + 40)
			});
		else
			Airflow:CreateAnimation(ListFrame,0.3,nil,{
				Size = UDim2.new(0, 200, 0, 0)
			});

			Airflow:CreateAnimation(ListFrame,0.3,nil,{
				BackgroundTransparency = 1
			});

			Airflow:CreateAnimation(MainFrame,0.3,nil,{
				BackgroundTransparency = 1
			});

			Airflow:CreateAnimation(LineV,0.3,nil,{
				BackgroundTransparency = 1
			});

			Airflow:CreateAnimation(LineV,0.3,nil,{
				BackgroundTransparency = 1
			});

			Airflow:CreateAnimation(UIStroke,0.3,nil,{
				Transparency = 1
			});

			Airflow:CreateAnimation(Icon,0.3,nil,{
				ImageTransparency = 1
			});

			Airflow:CreateAnimation(WindowName,0.3,nil,{
				TextTransparency = 1
			});

			Airflow:CreateAnimation(static,0.3,nil,{
				ImageTransparency = 1
			});
		end;
	end;

	AirflowUI.Name = Airflow:RandomString()
	AirflowUI.Parent = CoreGui
	AirflowUI.ResetOnSpawn = false
	AirflowUI.IgnoreGuiInset = true
	AirflowUI.ZIndexBehavior = Enum.ZIndexBehavior.Global;

	protect_gui(AirflowUI);
	Airflow:Blur(ListFrame);

	ListFrame.Active = true
	ListFrame.Name = Airflow:RandomString()
	ListFrame.Parent = AirflowUI
	ListFrame.BackgroundColor3 = Color3.fromRGB(166, 166, 166)
	ListFrame.BackgroundTransparency = 1
	ListFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ListFrame.BorderSizePixel = 0
	ListFrame.ClipsDescendants = true
	ListFrame.Position = UDim2.new(0, 100, 0, 100)
	ListFrame.Size = UDim2.new(0, 200, 0, 71)
	ListFrame.ZIndex = 120

	ListFrame:GetPropertyChangedSignal('Size'):Connect(function()
		if ListFrame.BackgroundTransparency >= 0.95 then
			AirflowUI.Enabled = false;
		else
			AirflowUI.Enabled = true;
		end;
	end)

	UICorner.CornerRadius = UDim.new(0, 2)
	UICorner.Parent = ListFrame

	MainFrame.Name = Airflow:RandomString()
	MainFrame.Parent = ListFrame
	MainFrame.AnchorPoint = Vector2.new(0, 1)
	MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
	MainFrame.BackgroundTransparency = 1
	MainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	MainFrame.BorderSizePixel = 0
	MainFrame.ClipsDescendants = true
	MainFrame.Position = UDim2.new(0, 0, 1, 0)
	MainFrame.Size = UDim2.new(1, 0, 1, -35)
	MainFrame.ZIndex = 123

	LineV.Name = Airflow:RandomString()
	LineV.Parent = MainFrame
	LineV.BackgroundColor3 = Color3.fromRGB(125, 125, 125)
	LineV.BackgroundTransparency = 1
	LineV.BorderColor3 = Color3.fromRGB(0, 0, 0)
	LineV.BorderSizePixel = 0
	LineV.Size = UDim2.new(1, 0, 0, 1)
	LineV.ZIndex = 124

	UIListLayout.Parent = MainFrame
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 5)

	UIListLayout:GetPropertyChangedSignal('AbsoluteContentSize'):Connect(function()
		if Response.Toggle then
			Airflow:CreateAnimation(ListFrame,0.3,nil,{
				Size = UDim2.new(0, 200, 0, UIListLayout.AbsoluteContentSize.Y + 40)
			});
		end;
	end)

	UIStroke.Transparency = 1
	UIStroke.Color = Color3.fromRGB(125, 125, 125)
	UIStroke.Parent = ListFrame

	Headers.Name = Airflow:RandomString()
	Headers.Parent = ListFrame
	Headers.AnchorPoint = Vector2.new(0.5, 0)
	Headers.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Headers.BackgroundTransparency = 1.000
	Headers.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Headers.BorderSizePixel = 0
	Headers.Position = UDim2.new(0.5, 0, 0, 5)
	Headers.Size = UDim2.new(1, -15, 0, 25)
	Headers.ZIndex = 120

	UIListLayout_2.Parent = Headers
	UIListLayout_2.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout_2.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout_2.VerticalAlignment = Enum.VerticalAlignment.Center
	UIListLayout_2.Padding = UDim.new(0, 5)

	Icon.Name = Airflow:RandomString()
	Icon.Parent = Headers
	Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Icon.BackgroundTransparency = 1.000
	Icon.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Icon.BorderSizePixel = 0
	Icon.Size = UDim2.new(0, 20, 0, 20)
	Icon.ZIndex = 122
	Icon.Image = Airflow:GetIcon(config.Icon);
	Icon.ImageTransparency = 1

	UICorner_2.CornerRadius = UDim.new(1, 0)
	UICorner_2.Parent = Icon

	WindowName.Name = Airflow:RandomString()
	WindowName.Parent = Headers
	WindowName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	WindowName.BackgroundTransparency = 1.000
	WindowName.BorderColor3 = Color3.fromRGB(0, 0, 0)
	WindowName.BorderSizePixel = 0
	WindowName.Size = UDim2.new(0, 60, 0, 20)
	WindowName.ZIndex = 122
	WindowName.Font = Enum.Font.GothamMedium
	WindowName.Text = config.Name
	WindowName.TextColor3 = Color3.fromRGB(255, 255, 255)
	WindowName.TextSize = 15.000
	WindowName.TextTransparency = 1

	static.Name = Airflow:RandomString()
	static.Parent = ListFrame
	static.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	static.BackgroundTransparency = 1.000
	static.BorderColor3 = Color3.fromRGB(0, 0, 0)
	static.BorderSizePixel = 0
	static.Size = UDim2.new(1, 0, 1, 0)
	static.ZIndex = 120
	static.Image = "rbxassetid://9579075682"
	static.ImageTransparency = 0.9
	static.ScaleType = Enum.ScaleType.Crop
	static.ImageTransparency = 1

	function Response:AddFrame(config) : KeyValue
		config = config or {};
		config.Key = config.Key or "key";
		config.Value = config.Value or "Value";

		local Frame = Instance.new("Frame")
		local name = Instance.new("TextLabel")
		local value = Instance.new("TextLabel")

		Frame.Parent = MainFrame
		Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Frame.BackgroundTransparency = 1.000
		Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Frame.BorderSizePixel = 0
		Frame.Size = UDim2.new(1, 0, 0, 25)
		Frame.ZIndex = 124

		name.Name = Airflow:RandomString()
		name.Parent = Frame
		name.AnchorPoint = Vector2.new(0, 0.5)
		name.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		name.BackgroundTransparency = 1.000
		name.BorderColor3 = Color3.fromRGB(0, 0, 0)
		name.BorderSizePixel = 0
		name.Position = UDim2.new(0, 10, 0.5, 0)
		name.Size = UDim2.new(1, 0, 1, 0)
		name.ZIndex = 125
		name.Font = Enum.Font.GothamMedium
		name.Text = config.Key
		name.TextColor3 = Color3.fromRGB(255, 255, 255)
		name.TextSize = 14.000
		name.TextXAlignment = Enum.TextXAlignment.Left

		value.Name = Airflow:RandomString()
		value.Parent = Frame
		value.AnchorPoint = Vector2.new(1, 0.5)
		value.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		value.BackgroundTransparency = 1.000
		value.BorderColor3 = Color3.fromRGB(0, 0, 0)
		value.BorderSizePixel = 0
		value.Position = UDim2.new(1, -10, 0.5, 0)
		value.Size = UDim2.new(1, 0, 1, 0)
		value.ZIndex = 125
		value.Font = Enum.Font.GothamMedium
		value.Text = config.Value
		value.TextColor3 = Color3.fromRGB(255, 255, 255)
		value.TextSize = 13.000
		value.TextTransparency = 0.500
		value.TextXAlignment = Enum.TextXAlignment.Right

		return {
			SetKey = function(self , KEY)
				config.Key = KEY;
				name.Text = config.Key
			end,

			SetValue = function(self , VALUE)
				config.Value = VALUE;
				value.Text = config.Value
			end,

			Visible = function(self , VALUE)
				Frame.Visible = VALUE;
			end,
		}
	end;

	ToggleFun(true);

	function Response:Visible(value)
		if value then
			Response.Toggle = true
			ToggleFun(true);
		else
			Response.Toggle = false
			ToggleFun(false);
		end;
	end;

	local dragToggle = nil;
	local dragSpeed = 0.25;
	local dragStart = nil;
	local startPos = nil;

	local function updateInput(input)
		local delta = input.Position - dragStart
		local position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X,
			startPos.Y.Scale, startPos.Y.Offset + delta.Y);

		Airflow:CreateAnimation(ListFrame,dragSpeed,nil,{
			Position = position
		});
	end;

	ListFrame.InputBegan:Connect(function(input)
		if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then 
			dragToggle = true
			dragStart = input.Position
			startPos = ListFrame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragToggle = false
				end
			end)
		end
	end)

	UserInputService.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
			if dragToggle then
				updateInput(input)
			end
		end
	end);

	return Response;
end;

do
	local Notifier = Instance.new("Frame")
	local UIListLayout = Instance.new("UIListLayout")

	Notifier.Name = Airflow:RandomString()
	Notifier.Parent = Airflow.ScreenGui
	Notifier.AnchorPoint = Vector2.new(1, 0)
	Notifier.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Notifier.BackgroundTransparency = 1.000
	Notifier.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Notifier.BorderSizePixel = 0
	Notifier.Position = UDim2.new(1, -5, 0, 5)
	Notifier.Size = UDim2.new(0, 150, 0, 10)

	UIListLayout.Parent = Notifier
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.Padding = UDim.new(0, 0)

	function Airflow:Notify(config)
		config = config or {};
		config.Title = config.Title or "Notification";
		config.Content = config.Content or "";
		config.Duration = config.Duration or 5;

		local Frame = Instance.new("Frame")
		local MainFrame = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local UIStroke = Instance.new("UIStroke")
		local static = Instance.new("ImageLabel")
		local Title = Instance.new("TextLabel")
		local Content = Instance.new("TextLabel")

		Frame.Parent = Notifier
		Frame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Frame.BackgroundTransparency = 1.000
		Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Frame.BorderSizePixel = 0
		Frame.Size = UDim2.new(0, 200, 0, 40)

		MainFrame.Name = Airflow:RandomString()
		MainFrame.Parent = Frame
		MainFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
		MainFrame.BackgroundTransparency = 0.200
		MainFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		MainFrame.BorderSizePixel = 0
		MainFrame.Size = UDim2.new(0, 200, 0, 40)
		MainFrame.ZIndex = 121
		MainFrame.Position = UDim2.fromScale(1,0)

		UICorner.CornerRadius = UDim.new(0, 4)
		UICorner.Parent = MainFrame

		UIStroke.Transparency = 0.570
		UIStroke.Color = Color3.fromRGB(66, 66, 66)
		UIStroke.Parent = MainFrame

		static.Name = Airflow:RandomString()
		static.Parent = MainFrame
		static.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		static.BackgroundTransparency = 1.000
		static.BorderColor3 = Color3.fromRGB(0, 0, 0)
		static.BorderSizePixel = 0
		static.Size = UDim2.new(1, 0, 1, 0)
		static.ZIndex = 120
		static.Image = "rbxassetid://9579075682"
		static.ImageTransparency = 0.900
		static.ScaleType = Enum.ScaleType.Crop

		Title.Name = Airflow:RandomString()
		Title.Parent = MainFrame
		Title.AnchorPoint = Vector2.new(0.5, 0)
		Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Title.BackgroundTransparency = 1.000
		Title.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Title.BorderSizePixel = 0
		Title.Position = UDim2.new(0.5, 0, 0, 5)
		Title.Size = UDim2.new(1, -10, 0, 15)
		Title.ZIndex = 123
		Title.Font = Enum.Font.GothamMedium
		Title.Text = config.Title
		Title.TextColor3 = Color3.fromRGB(255, 255, 255)
		Title.TextSize = 14.000
		Title.TextXAlignment = Enum.TextXAlignment.Left
		Title.TextTransparency = 1;

		task.delay(0.275,Airflow.CreateAnimation,Airflow,Title,0.4,nil,{
			TextTransparency = 0
		})

		Content.Name = Airflow:RandomString()
		Content.Parent = MainFrame
		Content.AnchorPoint = Vector2.new(0.5, 0)
		Content.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Content.BackgroundTransparency = 1.000
		Content.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Content.BorderSizePixel = 0
		Content.Position = UDim2.new(0.5, 0, 0, 20)
		Content.Size = UDim2.new(1, -10, 1, -20)
		Content.ZIndex = 123
		Content.Font = Enum.Font.GothamMedium
		Content.Text = config.Content
		Content.TextColor3 = Color3.fromRGB(255, 255, 255)
		Content.TextSize = 12.000
		Content.TextTransparency = 1
		Content.TextXAlignment = Enum.TextXAlignment.Left
		Content.TextYAlignment = Enum.TextYAlignment.Top
		task.delay(0.325,Airflow.CreateAnimation,Airflow,Content,0.5,nil,{
			TextTransparency = 0.3
		})

		local UpdateScale = function()
			local TitleScale = TextService:GetTextSize(Title.Text,Title.TextSize,Title.Font,Vector2.new(math.huge,math.huge));

			if not Content.Text:byte() then

				Airflow:CreateAnimation(Frame,0.2,nil,{
					Size = UDim2.fromOffset(TitleScale.X + 5 , 45);
				});

				Airflow:CreateAnimation(MainFrame,0.2,nil,{
					Size = UDim2.fromOffset(TitleScale.X + 5 , 40);
				});
			else
				local ContentScale = TextService:GetTextSize(Content.Text,Content.TextSize,Content.Font,Vector2.new(math.huge,math.huge));

				local Long = ((ContentScale.X > TitleScale.X) and ContentScale.X) or TitleScale.X;

				Airflow:CreateAnimation(Frame,0.2,nil,{
					Size = UDim2.fromOffset(Long + 10 , ContentScale.Y + 30);
				});

				Airflow:CreateAnimation(MainFrame,0.2,nil,{
					Size = UDim2.fromOffset(Long + 10 , ContentScale.Y + 25);
				});
			end;
		end;

		UpdateScale();

		Airflow:CreateAnimation(MainFrame,0.4,nil,{
			Position = UDim2.fromScale(0,0)
		})

		if typeof(config.Duration) == 'boolean' then
			return {
				Close = function()
					Airflow:CreateAnimation(MainFrame,0.4,nil,{
						Position = UDim2.new(1.5,100,0,0)
					}).Completed:Connect(function()
						Airflow:CreateAnimation(Frame,0.4,nil,{
							Size = UDim2.fromScale(0,0)
						}).Completed:Connect(function()
							Frame:Destroy()
						end)
					end)
				end,
				SetText = function(self , i)
					Title.Text = i;
					UpdateScale();
				end,
				SetContent = function(self , i)
					Content.Text = i;
					UpdateScale();
				end,
			}
		else
			task.delay(config.Duration,function()
				Airflow:CreateAnimation(MainFrame,0.4,nil,{
					Position = UDim2.new(1.5,100,0,0)
				}).Completed:Connect(function()
					Airflow:CreateAnimation(Frame,0.4,nil,{
						Size = UDim2.fromScale(0,0)
					}).Completed:Connect(function()
						Frame:Destroy()
					end)
				end)
			end)
		end;
	end;
end;

function Airflow:DrawLoader(loader_config : Loader)
	loader_config = loader_config or {};
	loader_config.Name = loader_config.Name or "airflow";
	loader_config.Icon = loader_config.Icon or Airflow.Config.Logo;
	loader_config.Highlight = loader_config.Highlight or Airflow.Config.Hightlight;
	
	local enum = {
		StatusTypes = {
			["Online"] = "Online",
			["Updating"] = "Updating",
			["NotUpdate"] = "NotUpdate",
			["Outdate"] = "Outdate",
			["Unknow"] = "Unknow",

		},
		StatusColors = {
			["Online"] = Color3.fromRGB(59, 230, 116),
			["Updating"] = Color3.fromRGB(230, 225, 78),
			["NotUpdate"] = Color3.fromRGB(230, 71, 74),
			["Outdate"] = Color3.fromRGB(230, 109, 121),
			["Unknow"] = Color3.fromRGB(230, 67, 69),
		},
		StatusTexts = {
			["Online"] = "Online",
			["Updating"] = "Updating",
			["NotUpdate"] = "Not Update",
			["Outdate"] = "Outdate",
			["Unknow"] = "???",
		},
	};
	
	local promis = {
		Enum = enum,	
	};
	
	promis.games = {};
	promis.isfirst = true;
	
	local Loader = Instance.new("ScreenGui")
	local ExeLoader = Instance.new("Frame")
	local UIStroke = Instance.new("UIStroke")
	local UIGradient = Instance.new("UIGradient")
	local UICorner = Instance.new("UICorner")
	local Header = Instance.new("Frame")
	local UIListLayout = Instance.new("UIListLayout")
	local Logo = Instance.new("ImageLabel")
	local UICorner_2 = Instance.new("UICorner")
	local HeaderText = Instance.new("TextLabel")
	local Body = Instance.new("Frame")
	local TabBths = Instance.new("Frame")
	local UICorner_3 = Instance.new("UICorner")
	local UIStroke_2 = Instance.new("UIStroke")
	local ScrollingFrame = Instance.new("ScrollingFrame")
	local UIListLayout_2 = Instance.new("UIListLayout")
	local TabFrame = Instance.new("Frame")
	local UICorner_4 = Instance.new("UICorner")

	Loader.Name = ".Loader="..Airflow:RandomString();
	Loader.Parent = CoreGui;
	Loader.ResetOnSpawn = false;
	Loader.IgnoreGuiInset = true;
	Loader.ZIndexBehavior = Enum.ZIndexBehavior.Global;
	
	protect_gui(Loader);

	ExeLoader.Name = "ExeLoader"
	ExeLoader.Parent = Loader
	ExeLoader.AnchorPoint = Vector2.new(0.5, 0.5)
	ExeLoader.BackgroundColor3 = Color3.fromRGB(77, 77, 77)
	ExeLoader.BackgroundTransparency = 0.200
	ExeLoader.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ExeLoader.BorderSizePixel = 0
	ExeLoader.Position = UDim2.new(0.5, 0, 0.5, 0)
	ExeLoader.Size = UDim2.new(0, 0, 0, 0)
	
	ExeLoader.ClipsDescendants = true;
	
	Airflow:Blur(ExeLoader);
	Airflow:CreateAnimation(ExeLoader,1.25,Enum.EasingStyle.Quint,{
		Size = UDim2.new(0, 450, 0, 325)
	});
	
	UIStroke.Transparency = 0.680
	UIStroke.Color = Color3.fromRGB(255, 255, 255)
	UIStroke.Parent = ExeLoader

	UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(0, 0, 0)), ColorSequenceKeypoint.new(0.87, Color3.fromRGB(0, 0, 0)), ColorSequenceKeypoint.new(0.88, Color3.fromRGB(177, 177, 177)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(177, 177, 177))}
	UIGradient.Rotation = -90
	UIGradient.Transparency = NumberSequence.new{NumberSequenceKeypoint.new(0.00, 0.60), NumberSequenceKeypoint.new(1.00, 0.60)}
	UIGradient.Parent = UIStroke

	UICorner.CornerRadius = UDim.new(0, 2)
	UICorner.Parent = ExeLoader

	Header.Name = "Header"
	Header.Parent = ExeLoader
	Header.AnchorPoint = Vector2.new(0.5, 0)
	Header.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Header.BackgroundTransparency = 1.000
	Header.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Header.BorderSizePixel = 0
	Header.Position = UDim2.new(0.5, 0, 0, 5)
	Header.Size = UDim2.new(1, -15, 0, 30)
	Header.ZIndex = 3

	UIListLayout.Parent = Header
	UIListLayout.FillDirection = Enum.FillDirection.Horizontal
	UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
	UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	UIListLayout.Padding = UDim.new(0, 3)

	Logo.Name = "Logo"
	Logo.Parent = Header
	Logo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	Logo.BackgroundTransparency = 1.000
	Logo.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Logo.BorderSizePixel = 0
	Logo.Size = UDim2.new(0, 30, 0, 30)
	Logo.ZIndex = 5
	Logo.Image = loader_config.Icon

	UICorner_2.CornerRadius = UDim.new(1, 0)
	UICorner_2.Parent = Logo

	HeaderText.Name = "HeaderText"
	HeaderText.Parent = Header
	HeaderText.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	HeaderText.BackgroundTransparency = 1.000
	HeaderText.BorderColor3 = Color3.fromRGB(0, 0, 0)
	HeaderText.BorderSizePixel = 0
	HeaderText.Size = UDim2.new(0, 83, 0, 20)
	HeaderText.Font = Enum.Font.GothamMedium
	HeaderText.Text = loader_config.Name
	HeaderText.TextColor3 = Color3.fromRGB(255, 255, 255)
	HeaderText.TextSize = 15.000
	HeaderText.TextTransparency = 0.400

	Body.Name = "Body"
	Body.Parent = ExeLoader
	Body.AnchorPoint = Vector2.new(0, 1)
	Body.BackgroundColor3 = Color3.fromRGB(12, 12, 12)
	Body.BackgroundTransparency = 0.300
	Body.BorderColor3 = Color3.fromRGB(0, 0, 0)
	Body.BorderSizePixel = 0
	Body.ClipsDescendants = true
	Body.Position = UDim2.new(0, 0, 1, 0)
	Body.Size = UDim2.new(1, 0, 1, -40)
	Body.ZIndex = 2

	TabBths.Name = "TabBths"
	TabBths.Parent = Body
	TabBths.AnchorPoint = Vector2.new(0, 0.5)
	TabBths.BackgroundColor3 = Color3.fromRGB(91, 91, 91)
	TabBths.BackgroundTransparency = 1.000
	TabBths.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TabBths.BorderSizePixel = 0
	TabBths.Position = UDim2.new(0, 5, 0.5, 0)
	TabBths.Size = UDim2.new(0, 125, 1, -10)
	TabBths.ZIndex = 2

	UICorner_3.CornerRadius = UDim.new(0, 2)
	UICorner_3.Parent = TabBths

	UIStroke_2.Transparency = 0.550
	UIStroke_2.Color = Color3.fromRGB(61, 61, 61)
	UIStroke_2.Parent = TabBths

	ScrollingFrame.Parent = TabBths
	ScrollingFrame.Active = true
	ScrollingFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	ScrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
	ScrollingFrame.BackgroundTransparency = 1.000
	ScrollingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	ScrollingFrame.BorderSizePixel = 0
	ScrollingFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
	ScrollingFrame.Size = UDim2.new(1, -5, 1, -5)
	ScrollingFrame.ZIndex = 5
	ScrollingFrame.ScrollBarThickness = 0

	UIListLayout_2.Parent = ScrollingFrame
	UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
	UIListLayout_2.Padding = UDim.new(0, 3)

	TabFrame.Name = "TabFrame"
	TabFrame.Parent = Body
	TabFrame.AnchorPoint = Vector2.new(0, 0.5)
	TabFrame.BackgroundColor3 = Color3.fromRGB(91, 91, 91)
	TabFrame.BackgroundTransparency = 1.000
	TabFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
	TabFrame.BorderSizePixel = 0
	TabFrame.Position = UDim2.new(0, 135, 0.5, 0)
	TabFrame.Size = UDim2.new(1, -140, 1, -10)
	TabFrame.ZIndex = 2

	UICorner_4.CornerRadius = UDim.new(0, 2)
	UICorner_4.Parent = TabFrame
	
	function promis:Update()
		local WindowNameSize = TextService:GetTextSize(HeaderText.Text,HeaderText.TextSize,HeaderText.Font,Vector2.new(math.huge,math.huge));

		HeaderText.Size = UDim2.new(0, WindowNameSize.X + 4, 0, 20)
	end;
	
	promis:Update()
	
	function promis:DrawGame(loader_game : LoaderGame)
		
		loader_game = loader_game or {};
		loader_game.Name = loader_game.Name or "Counter Strike";
		loader_game.Logo = loader_game.Logo or "rbxassetid://75488333338873";
		loader_game.Description = loader_game.Description or string.format("Welcome, %s!", Client.DisplayName);
		
		local cl_promis = {
			Enum = enum,
			selectedLoader = "",
		};
		
		cl_promis.versions = {};
		cl_promis.isfirst = true;
		
		local LoaderGame = Instance.new("Frame")
		local UICorner = Instance.new("UICorner")
		local GameLogo = Instance.new("ImageLabel")
		local UICorner_2 = Instance.new("UICorner")
		local GameName = Instance.new("TextLabel")
		local Line = Instance.new("Frame")

		LoaderGame.Name = "LoaderGame"
		LoaderGame.Parent = ScrollingFrame
		LoaderGame.BackgroundColor3 = Color3.fromRGB(91, 91, 91)
		LoaderGame.BackgroundTransparency = 0.650
		LoaderGame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		LoaderGame.BorderSizePixel = 0
		LoaderGame.ClipsDescendants = true
		LoaderGame.Size = UDim2.new(1, 0, 0, 35)
		LoaderGame.ZIndex = 6

		UICorner.CornerRadius = UDim.new(0, 4)
		UICorner.Parent = LoaderGame

		GameLogo.Name = "GameLogo"
		GameLogo.Parent = LoaderGame
		GameLogo.AnchorPoint = Vector2.new(0, 0.5)
		GameLogo.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		GameLogo.BackgroundTransparency = 1.000
		GameLogo.BorderColor3 = Color3.fromRGB(0, 0, 0)
		GameLogo.BorderSizePixel = 0
		GameLogo.Position = UDim2.new(0, 5, 0.5, 0)
		GameLogo.Size = UDim2.new(0, 19, 0, 19)
		GameLogo.ZIndex = 7
		GameLogo.Image = loader_game.Logo
		GameLogo.ImageTransparency = 0.300

		UICorner_2.CornerRadius = UDim.new(1, 0)
		UICorner_2.Parent = GameLogo

		GameName.Name = "GameName"
		GameName.Parent = LoaderGame
		GameName.AnchorPoint = Vector2.new(0, 0.5)
		GameName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		GameName.BackgroundTransparency = 1.000
		GameName.BorderColor3 = Color3.fromRGB(0, 0, 0)
		GameName.BorderSizePixel = 0
		GameName.Position = UDim2.new(0, 30, 0.5, 0)
		GameName.Size = UDim2.new(1, 50, 0, 20)
		GameName.ZIndex = 7
		GameName.Font = Enum.Font.GothamMedium
		GameName.Text = loader_game.Name
		GameName.TextColor3 = Color3.fromRGB(255, 255, 255)
		GameName.TextSize = 13.000
		GameName.TextTransparency = 0.300
		GameName.TextWrapped = true
		GameName.TextXAlignment = Enum.TextXAlignment.Left

		Line.Name = "Line"
		Line.Parent = LoaderGame
		Line.AnchorPoint = Vector2.new(1, 0.5)
		Line.BackgroundColor3 = loader_config.Highlight
		Line.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Line.BorderSizePixel = 0
		Line.Position = UDim2.new(1, 0, 0.5, 0)
		Line.Size = UDim2.new(0, 2, 1, 0)
		Line.ZIndex = 8;
		
		----------- Menu -----------
		
		local bthFrame = Instance.new("Frame")
		local versionLoaders = Instance.new("Frame")
		local UIStroke = Instance.new("UIStroke")
		local UICorner = Instance.new("UICorner")
		local ScrollingFrame = Instance.new("ScrollingFrame")
		local UIListLayout = Instance.new("UIListLayout")
		local Description = Instance.new("TextLabel")
		local Status = Instance.new("TextLabel")
		local Value = Instance.new("TextLabel")
		local LastUpdate = Instance.new("TextLabel")
		local Value_2 = Instance.new("TextLabel")
		local LoadButton = Instance.new("TextButton")
		local UIStroke_2 = Instance.new("UIStroke")
		local UICorner_2 = Instance.new("UICorner")


		bthFrame.Name = "bthFrame"
		bthFrame.Parent = TabFrame
		bthFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		bthFrame.BackgroundTransparency = 1.000
		bthFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		bthFrame.BorderSizePixel = 0
		bthFrame.Size = UDim2.new(1, 0, 1, 0)
		bthFrame.ZIndex = 4

		versionLoaders.Name = "versionLoaders"
		versionLoaders.Parent = bthFrame
		versionLoaders.AnchorPoint = Vector2.new(0.5, 0)
		versionLoaders.BackgroundColor3 = Color3.fromRGB(91, 91, 91)
		versionLoaders.BackgroundTransparency = 1.000
		versionLoaders.BorderColor3 = Color3.fromRGB(0, 0, 0)
		versionLoaders.BorderSizePixel = 0
		versionLoaders.Position = UDim2.new(0.5, 0, 0, 0)
		versionLoaders.Size = UDim2.new(1, -5, 0, 150)
		versionLoaders.ZIndex = 5

		UIStroke.Transparency = 0.550
		UIStroke.Color = Color3.fromRGB(61, 61, 61)
		UIStroke.Parent = versionLoaders

		UICorner.CornerRadius = UDim.new(0, 2)
		UICorner.Parent = versionLoaders

		ScrollingFrame.Parent = versionLoaders
		ScrollingFrame.Active = true
		ScrollingFrame.AnchorPoint = Vector2.new(0.5, 0.5)
		ScrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		ScrollingFrame.BackgroundTransparency = 1.000
		ScrollingFrame.BorderColor3 = Color3.fromRGB(0, 0, 0)
		ScrollingFrame.BorderSizePixel = 0
		ScrollingFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
		ScrollingFrame.Size = UDim2.new(1, -5, 1, -5)
		ScrollingFrame.ZIndex = 5
		ScrollingFrame.ScrollBarThickness = 0

		UIListLayout.Parent = ScrollingFrame
		UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
		UIListLayout.Padding = UDim.new(0, 3)

		Description.Name = "Description"
		Description.Parent = bthFrame
		Description.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Description.BackgroundTransparency = 1.000
		Description.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Description.BorderSizePixel = 0
		Description.Position = UDim2.new(0, 2, 0, 155)
		Description.Size = UDim2.new(1, -5, 0, 35)
		Description.ZIndex = 2
		Description.Font = Enum.Font.GothamMedium
		Description.Text = loader_game.Description
		Description.TextColor3 = Color3.fromRGB(230, 230, 230)
		Description.TextSize = 14.000
		Description.TextXAlignment = Enum.TextXAlignment.Left
		Description.TextYAlignment = Enum.TextYAlignment.Top

		Status.Name = "Status"
		Status.Parent = bthFrame
		Status.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Status.BackgroundTransparency = 1.000
		Status.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Status.BorderSizePixel = 0
		Status.Position = UDim2.new(0, 2, 0, 190)
		Status.Size = UDim2.new(1, -5, 0, 15)
		Status.ZIndex = 2
		Status.Font = Enum.Font.GothamMedium
		Status.Text = "Status:"
		Status.TextColor3 = Color3.fromRGB(230, 230, 230)
		Status.TextSize = 14.000
		Status.TextXAlignment = Enum.TextXAlignment.Left

		Value.Name = "Value"
		Value.Parent = Status
		Value.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Value.BackgroundTransparency = 1.000
		Value.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Value.BorderSizePixel = 0
		Value.Size = UDim2.new(1, 0, 1, 0)
		Value.ZIndex = 2
		Value.Font = Enum.Font.GothamMedium
		Value.Text = "???"
		Value.TextColor3 = Color3.fromRGB(7, 230, 126)
		Value.TextSize = 14.000
		Value.TextXAlignment = Enum.TextXAlignment.Right

		LastUpdate.Name = "LastUpdate"
		LastUpdate.Parent = bthFrame
		LastUpdate.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		LastUpdate.BackgroundTransparency = 1.000
		LastUpdate.BorderColor3 = Color3.fromRGB(0, 0, 0)
		LastUpdate.BorderSizePixel = 0
		LastUpdate.Position = UDim2.new(0, 2, 0, 210)
		LastUpdate.Size = UDim2.new(1, -5, 0, 15)
		LastUpdate.ZIndex = 2
		LastUpdate.Font = Enum.Font.GothamMedium
		LastUpdate.Text = "Last Update:"
		LastUpdate.TextColor3 = Color3.fromRGB(230, 230, 230)
		LastUpdate.TextSize = 14.000
		LastUpdate.TextXAlignment = Enum.TextXAlignment.Left

		Value_2.Name = "Value"
		Value_2.Parent = LastUpdate
		Value_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
		Value_2.BackgroundTransparency = 1.000
		Value_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
		Value_2.BorderSizePixel = 0
		Value_2.Size = UDim2.new(1, 0, 1, 0)
		Value_2.ZIndex = 2
		Value_2.Font = Enum.Font.GothamMedium
		Value_2.Text = "???"
		Value_2.TextColor3 = Color3.fromRGB(230, 230, 230)
		Value_2.TextSize = 14.000
		Value_2.TextXAlignment = Enum.TextXAlignment.Right

		LoadButton.Name = "LoadButton"
		LoadButton.Parent = bthFrame
		LoadButton.AnchorPoint = Vector2.new(0.5, 1)
		LoadButton.BackgroundColor3 = Color3.fromRGB(63, 63, 63)
		LoadButton.BackgroundTransparency = 0.400
		LoadButton.BorderColor3 = Color3.fromRGB(0, 0, 0)
		LoadButton.BorderSizePixel = 0
		LoadButton.Position = UDim2.new(0.5, 0, 1, -5)
		LoadButton.Size = UDim2.new(1, -5, 0, 30)
		LoadButton.ZIndex = 4
		LoadButton.Font = Enum.Font.GothamMedium
		LoadButton.Text = "Load"
		LoadButton.TextColor3 = Color3.fromRGB(255, 255, 255)
		LoadButton.TextSize = 14.000

		UIStroke_2.Transparency = 0.740
		UIStroke_2.Color = Color3.fromRGB(131, 131, 131)
		UIStroke_2.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
		UIStroke_2.Parent = LoadButton

		UICorner_2.CornerRadius = UDim.new(0, 2)
		UICorner_2.Parent = LoadButton;
		
		function cl_promis:Visible(value)
			if value then
				Line.Visible = true;
				bthFrame.Visible = true;
				
			else
				Line.Visible = false;
				bthFrame.Visible = false;
			end;
		end;
		
		function cl_promis:SetStatus(Type)
			Value.TextColor3 = cl_promis.Enum.StatusColors[Type];
			
			Value.Text = cl_promis.Enum.StatusTexts[Type];
		end;
		
		cl_promis:SetStatus(cl_promis.Enum.StatusTypes.Unknow);
		
		if promis.isfirst then
			promis.isfirst = false;
			
			cl_promis:Visible(true);
		else
			cl_promis:Visible(false);
		end;
		
		table.insert(promis.games,{
			Callback = cl_promis.Visible,
			_ev = cl_promis,
			f = bthFrame,
		});
		
		Airflow:NewInput(LoaderGame,function()
			for i,v in next , promis.games do
				if v.f == bthFrame then
					v.Callback(v._ev,true);
				else
					v.Callback(v._ev,false);
				end;
			end;
		end);
		
		local loaded = false;
		
		LoadButton.MouseButton1Click:Connect(function()
			if loaded then
				return;
			end;
			
			loaded = true;
			
			local l,m;
	
			if typeof(cl_promis.selectedLoader) == "function" then
				task.spawn(function()
					pcall(cl_promis.selectedLoader);
				end)
				l = true;
				
			else
				task.spawn(function()
					l , m = pcall(function()
						loadstring(cl_promis.selectedLoader)();
					end);
				end);
			end;
			
			task.wait(0.1);
			
			if l then
				Airflow:Notify({
					Content = "Loading",
					Title = "Loader",
					Duration = 5,
				});
				
				Airflow:CreateAnimation(ExeLoader,0.75,Enum.EasingStyle.Quint,{
					Size = UDim2.new(0, 0, 0, 0)
				});
				
				task.wait(1.25)
				
				Loader:Destroy();
			else
				loaded = false;
				Airflow:Notify({
					Content = "Failed to Load\n"..(m or "failed"),
					Title = "Error",
					Duration = 5,
				});
			end
		end);
		
		function cl_promis:DrawVersion(loader_version : LoaderVersion)
			loader_version = loader_version or {};
			loader_version.Name = loader_version.Name or "Live";
			loader_version.Status = loader_version.Status or cl_promis.StatusTypes.Unknow;
			loader_version.LastUpdate = loader_version.LastUpdate or tick();
			
			local LoaderVersion = Instance.new("Frame")
			local UICorner = Instance.new("UICorner")
			local GameName = Instance.new("TextLabel")
			local Line = Instance.new("Frame")

			LoaderVersion.Name = "LoaderVersion"
			LoaderVersion.Parent = ScrollingFrame
			LoaderVersion.BackgroundColor3 = Color3.fromRGB(91, 91, 91)
			LoaderVersion.BackgroundTransparency = 1.000
			LoaderVersion.BorderColor3 = Color3.fromRGB(255, 255, 255)
			LoaderVersion.BorderSizePixel = 0
			LoaderVersion.ClipsDescendants = true
			LoaderVersion.Size = UDim2.new(1, 0, 0, 35)
			LoaderVersion.ZIndex = 6

			UICorner.CornerRadius = UDim.new(0, 4)
			UICorner.Parent = LoaderVersion

			GameName.Name = "GameName"
			GameName.Parent = LoaderVersion
			GameName.AnchorPoint = Vector2.new(0, 0.5)
			GameName.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			GameName.BackgroundTransparency = 1.000
			GameName.BorderColor3 = Color3.fromRGB(0, 0, 0)
			GameName.BorderSizePixel = 0
			GameName.Position = UDim2.new(0, 10, 0.5, 0)
			GameName.Size = UDim2.new(1, 50, 0, 20)
			GameName.ZIndex = 7
			GameName.Font = Enum.Font.GothamMedium
			GameName.Text = loader_version.Name
			GameName.TextColor3 = Color3.fromRGB(255, 255, 255)
			GameName.TextSize = 13.000
			GameName.TextTransparency = 0.300
			GameName.TextWrapped = true
			GameName.TextXAlignment = Enum.TextXAlignment.Left

			Line.Name = "Line"
			Line.Parent = LoaderVersion
			Line.AnchorPoint = Vector2.new(0, 0.5)
			Line.BackgroundColor3 = loader_config.Highlight
			Line.BorderColor3 = Color3.fromRGB(0, 0, 0)
			Line.BorderSizePixel = 0
			Line.Position = UDim2.new(0, 0, 0.5, 0)
			Line.Size = UDim2.new(0, 2, 1, 0)
			Line.ZIndex = 8;
			
			local calb = function(value)
				if value then
					Airflow:CreateAnimation(Line,0.25,Enum.EasingStyle.Quint,{
						Position = UDim2.new(0, 0, 0.5, 0)
					});
					
					Airflow:CreateAnimation(GameName,0.25,Enum.EasingStyle.Quint,{
						Position = UDim2.new(0, 10, 0.5, 0)
					});
					
					cl_promis.selectedLoader = loader_version.LoadScript;
					cl_promis:SetStatus(loader_version.Status);
					
					if typeof(loader_version.LastUpdate) == "string" then
						Value_2.Text = loader_version.LastUpdate
					else
						local data = os.date("*t", loader_version.LastUpdate);
						Value_2.Text = string.format("%s:%s:%s",tostring(data.day),tostring(data.month),tostring(data.year))
					end;
					
				else
					Airflow:CreateAnimation(Line,0.25,Enum.EasingStyle.Quint,{
						Position = UDim2.new(0, -10, 0.5, 0)
					});
					Airflow:CreateAnimation(GameName,0.25,Enum.EasingStyle.Quint,{
						Position = UDim2.new(0, 5, 0.5, 0)
					});
				end;
			end;
			
			if cl_promis.isfirst then
				cl_promis.isfirst = false;
				
				calb(true);
			else
				calb(false);
			end;
			
			table.insert(cl_promis.versions,{
				Callback = calb,
				_f = LoaderVersion
			})
			
			Airflow:NewInput(LoaderVersion,function()
				for i,v in next , cl_promis.versions do
					if v._f == LoaderVersion then
						v.Callback(true);
					else
						v.Callback(false);
					end;
				end;
			end)
		end;
		
		return cl_promis;
	end;
	
	
	return promis;
end;

return Airflow;
