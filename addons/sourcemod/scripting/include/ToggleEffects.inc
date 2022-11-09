#if defined _GlobalEffects_Included_
 #endinput
#endif
#define _GlobalEffects_Included_

/**
 * Returns whether the client would like special effects on or off.
 *
 * @param client    The client index of the player
 * @return          True/False
 */
native bool ShowClientEffects(int client); 

public SharedPlugin __pl_ccc =
{
	name = "ToggleEffects",
	file = "ToggleEffects.smx",
#if defined REQUIRE_PLUGIN
	required = 1
#else
	required = 0
#endif
};

#if !defined REQUIRE_PLUGIN
public __pl_ccc_SetNTVOptional() {
	MarkNativeAsOptional("ShowClientEffects");
}
#endif
