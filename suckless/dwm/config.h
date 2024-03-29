/* See LICENSE file for copyright and license details. */

/* appearance */
static const unsigned int gappx     = 6;        /* gaps between windows */
static const unsigned int borderpx  = 3;        /* border pixel of windows */
static const unsigned int snap      = 32;       /* snap pixel */
static const unsigned int systraypinning = 0;   /* 0: sloppy systray follows selected monitor, >0: pin systray to monitor X */
static const unsigned int systrayonleft = 0;    /* 0: systray in the right corner, >0: systray on left of status text */
static const unsigned int systrayspacing = 2;   /* systray spacing */
static const unsigned int systrayiconsize = 16; /* systray icon size in px */
static const int systraypinningfailfirst = 1;   /* 1: if pinning fails, display systray on the first monitor, False: display systray on the last monitor*/
static const int showsystray        = 1;        /* 0 means no systray */
static const int showbar            = 1;        /* 0 means no bar */
static const int topbar             = 1;        /* 0 means bottom bar */
static const int user_bh            = 28;       /* 0 means that dwm will calculate bar height, >= 1 means dwm will user_bh as bar height */
static const char *fonts[]          = { "JetBrainsMono Nerd Font:size=9:style=medium", "AR PL UKai CN:size=10:style=medium", "TsangerJinKai05:size=9", "LXGW WenKai Mono:size=9", "monospace:size=9" };
static const char dmenufont[]       = "JetBrainsMono Nerd Font:size=9";
static const char dmenuheight[]     = "28";

// dark blue colors
// #define COL_PRIM "#4f7da4"
// #define COL_BACK "#2a2e32"
// #define COL_FORE "#aaaaaa"
// static const char col_prim[]        = COL_PRIM;
// static const char col_back[]        = COL_BACK;
// static const char col_fore[]        = COL_FORE;
// static const char col_sel_fore[]    = "#ffffff";
// static const char col_hide[]        = "#273152";
// static const char col_unsel[]       = "#273e52";
// static const char col_unsel_fore[]  = "#aaaaaa";
// static const char *colors[][3]      = {
// 	/*                fg               bg         border   */
// 	[SchemeNorm]  = { col_fore,        col_back,  col_unsel },
// 	[SchemeSel]   = { col_sel_fore,    col_prim,  col_prim  },
// 	[SchemeUnsel] = { col_unsel_fore,  col_unsel, col_unsel },
// 	[SchemeHid]   = { col_fore,        col_hide,  col_hide  },
// };

// dark green scheme
#define COL_PRIM "#13a4b6"
#define COL_BACK "#282c34"
#define COL_FORE "#bbc2cf"
static const char col_back[]        = COL_BACK;
static const char col_fore[]        = COL_FORE;
static const char col_prim[]        = COL_PRIM;
static const char col_back_alt[]    = "#444444";
static const char col_prim_alt[]    = "#0d727f";
static const char *colors[][3]      = {
       /*               fg         bg            border       */
       [SchemeNorm]  = { col_fore, col_back,     col_back_alt },
       [SchemeSel]   = { col_back, col_prim,     col_prim     },
       [SchemeUnsel] = { col_back, col_prim_alt, col_prim_alt },
       [SchemeHid]   = { col_back, col_prim_alt, col_prim_alt },
};


// static const char col_prim[]        = "#005577"; /* origin cyan */

/* tagging */
static const char *tags[] = { "临", "兵", "斗", "者", "皆", "阵", "列", "前", "行" };
/* static const char *tags[] = { "一", "二", "三", "四", "五", "六", "七", "八", "九" }; */

static const Rule rules[] = {
	/* xprop(1):
	 *	WM_CLASS(STRING) = instance, class
	 *	WM_NAME(STRING) = title
	 */
	/* class      instance    title       tags mask     isfloating   monitor */
	{ "Gimp",     NULL,       NULL,       0,            1,           -1 },
	{ "Firefox",  NULL,       NULL,       1 << 8,       0,           -1 },
};

/* layout(s) */
static const float mfact     = 0.50; /* factor of master area size [0.05..0.95] */
static const int nmaster     = 1;    /* number of clients in master area */
static const int resizehints = 0;    /* 1 means respect size hints in tiled resizals */
static const int lockfullscreen = 1; /* 1 will force focus on the fullscreen window */

static const Layout layouts[] = {
	/* symbol     arrange function */
	{ "[]=",      tile },    /* first entry is default */
	{ "><>",      NULL },    /* no layout function means floating behavior */
	{ "[M]",      monocle },
};

/* key definitions */
#define MODKEY Mod4Mask
#define TAGKEYS(KEY,TAG) \
	{ MODKEY,                       KEY,      view,           {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask,           KEY,      toggleview,     {.ui = 1 << TAG} }, \
	{ MODKEY|ShiftMask,             KEY,      tag,            {.ui = 1 << TAG} }, \
	{ MODKEY|ControlMask|ShiftMask, KEY,      toggletag,      {.ui = 1 << TAG} },

/* helper for spawning shell commands in the pre dwm-5.0 fashion */
#define SHCMD(cmd) { .v = (const char*[]){ "/bin/sh", "-c", cmd, NULL } }

/* commands */
#define ROFI_THEME_STR "*{primary:" COL_PRIM ";background:" COL_BACK ";}"
static char dmenumon[2] = "0"; /* component of dmenucmd, manipulated in spawn() */
static const char *dmenucmd[]     = { "dmenu_run", "-m", dmenumon, "-fn", dmenufont, "-nb", COL_BACK, "-nf", COL_FORE, "-sb", col_prim, "-sf", col_back, "-h", dmenuheight, "-p", "RUN", "-h", "20", NULL };
static const char *termcmd[]      = { "st", NULL };
static const char *rofiruncmd[]   = { "rofi", "-show", "run",  "-theme-str", ROFI_THEME_STR, NULL};
static const char *rofidruncmd[]  = { "rofi", "-show", "drun", "-theme-str", ROFI_THEME_STR, NULL};

static Key keys[] = {
	/* modifier                     key        function        argument */
	{ MODKEY,                       XK_p,      spawn,          {.v = dmenucmd} },
	{ MODKEY,                       XK_o,      spawn,          {.v = rofiruncmd} },
	{ MODKEY|ShiftMask,             XK_p,      spawn,          {.v = rofidruncmd} },
	{ MODKEY|ShiftMask,             XK_Return, spawn,          {.v = termcmd } },
	{ MODKEY,                       XK_b,      togglebar,      {0} },
	{ MODKEY,                       XK_j,      focusstackvis,  {.i = +1 } },
	{ MODKEY,                       XK_k,      focusstackvis,  {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_j,      focusstackhid,  {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_k,      focusstackhid,  {.i = -1 } },
	{ MODKEY,                       XK_i,      incnmaster,     {.i = +1 } },
	{ MODKEY,                       XK_d,      incnmaster,     {.i = -1 } },
	{ MODKEY,                       XK_h,      setmfact,       {.f = -0.05} },
	{ MODKEY,                       XK_l,      setmfact,       {.f = +0.05} },
	{ MODKEY|ControlMask,           XK_h,      setmfact,       {.f = -0.05} },
	{ MODKEY|ControlMask,           XK_l,      setmfact,       {.f = +0.05} },
	{ MODKEY,                       XK_Return, zoom,           {0} },
	{ MODKEY,                       XK_Tab,    view,           {0} },
	{ MODKEY|ShiftMask,             XK_c,      killclient,     {0} },
	{ MODKEY,                       XK_t,      setlayout,      {.v = &layouts[0]} },
	{ MODKEY,                       XK_f,      setlayout,      {.v = &layouts[1]} },
	{ MODKEY,                       XK_m,      setlayout,      {.v = &layouts[2]} },
	{ MODKEY,                       XK_space,  setlayout,      {0} },
	{ MODKEY|ShiftMask,             XK_space,  togglefloating, {0} },
	{ MODKEY,                       XK_0,      view,           {.ui = ~0 } },
	{ MODKEY|ShiftMask,             XK_0,      tag,            {.ui = ~0 } },
	{ MODKEY,                       XK_comma,  focusmon,       {.i = -1 } },
	{ MODKEY,                       XK_period, focusmon,       {.i = +1 } },
	{ MODKEY|ShiftMask,             XK_comma,  tagmon,         {.i = -1 } },
	{ MODKEY|ShiftMask,             XK_period, tagmon,         {.i = +1 } },
	{ MODKEY,                       XK_s,      show,           {0} },
	{ MODKEY,                       XK_h,      hide,           {0} },
	TAGKEYS(                        XK_1,                      0)
	TAGKEYS(                        XK_2,                      1)
	TAGKEYS(                        XK_3,                      2)
	TAGKEYS(                        XK_4,                      3)
	TAGKEYS(                        XK_5,                      4)
	TAGKEYS(                        XK_6,                      5)
	TAGKEYS(                        XK_7,                      6)
	TAGKEYS(                        XK_8,                      7)
	TAGKEYS(                        XK_9,                      8)
	{ MODKEY|ControlMask,           XK_q,      quit,           {0} },
};

/* button definitions */
/* click can be ClkTagBar, ClkLtSymbol, ClkStatusText, ClkWinTitle, ClkClientWin, or ClkRootWin */
static Button buttons[] = {
	/* click                event mask      button          function        argument */
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
	{ ClkWinTitle,          0,              Button2,        zoom,           {0} },
	{ ClkStatusText,        0,              Button2,        spawn,          {.v = termcmd } },
	{ ClkClientWin,         MODKEY,         Button1,        movemouse,      {0} },
	{ ClkClientWin,         MODKEY,         Button2,        togglefloating, {0} },
	{ ClkClientWin,         MODKEY,         Button3,        resizemouse,    {0} },
	{ ClkTagBar,            0,              Button1,        view,           {0} },
	{ ClkTagBar,            0,              Button3,        toggleview,     {0} },
	{ ClkTagBar,            MODKEY,         Button1,        tag,            {0} },
	{ ClkTagBar,            MODKEY,         Button3,        toggletag,      {0} },
	{ ClkWinTitle,          0,              Button1,        togglewin,      {0} },
};

