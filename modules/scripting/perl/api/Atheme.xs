#include "atheme_perl.h"

typedef sourceinfo_t *Atheme_Sourceinfo;
typedef perl_command_t *Atheme_Command;
typedef service_t *Atheme_Service;
typedef user_t *Atheme_User;
typedef object_t *Atheme_Object;
typedef object_t *Atheme_Object_MetadataHash;
typedef myentity_t *Atheme_Entity;
typedef myuser_t *Atheme_Account;
typedef channel_t *Atheme_Channel;
typedef chanuser_t *Atheme_ChanUser;
typedef mychan_t *Atheme_ChannelRegistration;

typedef perl_list_t *Atheme_Internal_List;


MODULE = Atheme			PACKAGE = Atheme

void
request_module_dependency(const char *module_name)
CODE:
	if (module_request(module_name) == false)
		Perl_croak(aTHX_ "Failed to load dependency %s", module_name);

	module_t *mod = module_find(module_name);
	module_t *me = module_find(PERL_MODULE_NAME);

	if (mod != NULL && me != NULL)
	{
		slog(LG_DEBUG, "Atheme::request_module_dependency: adding %s as a dependency to %s",
				PERL_MODULE_NAME, module_name);
		mowgli_node_add(mod, mowgli_node_create(), &me->deplist);
		mowgli_node_add(me, mowgli_node_create(), &mod->dephost);
	}

INCLUDE: services.xs
INCLUDE: sourceinfo.xs
INCLUDE: commands.xs
INCLUDE: user.xs
INCLUDE: object.xs
INCLUDE: metadata.xs
INCLUDE: account.xs
INCLUDE: channel.xs
INCLUDE: channelregistration.xs

INCLUDE: internal_list.xs