/*

databomb
Global Special Effects Options

*/

#include <sourcemod>
#include <clientprefs>

#pragma semicolon 1
#pragma newdecls required

bool g_bShowSpecialEffects[MAXPLAYERS + 1];
Handle gH_Cookie_SpecialFX = INVALID_HANDLE;

public Plugin myinfo =
{
	name = "Global Special Effects Options",
	author = "databomb",
	description = "A helper function for the native to set global effects.",
	version = "1.0.0",
	url = "vintagejailbreak.org"
};

public void OnPluginStart()
{
	if (LibraryExists("clientprefs"))
	{
		gH_Cookie_SpecialFX = RegClientCookie("Display_Special_FX", "Controls whether special effects are displayed to the client.", CookieAccess_Protected);
		SetCookieMenuItem(CookieMenu_GlobalEffects, 0, "Toggle All Special FX");
	}
	else
	{
		SetFailState("Could not find client preferences library!");
	}
}

public APLRes AskPluginLoad2(Handle myself, bool late, char[] error, int err_max)
{
	CreateNative("ShowClientEffects", Native_ShowClientEffects);
	RegPluginLibrary("specialfx");
	return APLRes_Success;
}

public int Native_ShowClientEffects(Handle plugin, int numParams)
{
	int client = GetNativeCell(1);
	return view_as<int>(g_bShowSpecialEffects[client]);
}

public void CookieMenu_GlobalEffects(int client, CookieMenuAction selection, any info, char[] buffer, int maxlen)
{
	if (selection != CookieMenuAction_DisplayOption)
	{
		// toggle the output for this client
		g_bShowSpecialEffects[client] = g_bShowSpecialEffects[client] ^ true;
		
		if (g_bShowSpecialEffects[client])
		{
			PrintToChat(client, "\x04Toggled Special FX To: [\x01ON\x04] (You'll see everyone else's special effects.)");
		}
		else
		{
			PrintToChat(client, "\x04Toggled Special FX To: [\x01OFF\x04] (You won't see anyone's special effects.)");
		}

		// update cookie
		char sDataToSend[5];
		IntToString(g_bShowSpecialEffects[client], sDataToSend, sizeof(sDataToSend));
		SetClientCookie(client, gH_Cookie_SpecialFX, sDataToSend);
	}
}

public void OnClientCookiesCached(int client)
{
	char sCookie[5];

	GetClientCookie(client, gH_Cookie_SpecialFX, sCookie, sizeof(sCookie));
	if (StrEqual(sCookie, ""))
	{
		// set default
		g_bShowSpecialEffects[client] = true;
	}
	else
	{
		g_bShowSpecialEffects[client] = view_as<bool>(StringToInt(sCookie));
	}
}
