# Secret Village — Studio setup

## ServerScriptService
Enable these scripts:

- `SecretVillageCore.server.lua` — new authoritative timer/economy/save controller.
- `SecretVillageSecrets.server.lua` — 10 secrets.
- `SecretVillageInventory.server.lua` — utility tools.
- `SecretVillageWorld.server.lua` — village buildings/events/fishing.
- `SecretVillageEconomy.server.lua` — food/courier.
- `SecretVillageSocial.server.lua` — progression.

### IMPORTANT
Disable the legacy `SecretVillage.server.lua` before testing the v2 core. It contains the old global timer and old job remotes and will conflict with the new controller.

Also disable `SecretVillageHUD.client.lua` because `SecretVillage.client.lua` is now the unified HUD.

## StarterPlayerScripts
Keep:

- `SecretVillage.client.lua`

Disable/remove:

- `SecretVillageHUD.client.lua`

## ReplicatedStorage
The scripts create these automatically:

- `SecretVillageRemotes`
- `SecretVillageTools`
- `SecretVillage` configuration folder (the `Config` ModuleScript should be placed under a folder named `SecretVillage`).

## DataStore
For persistence while testing in Studio:

1. Publish the experience to Roblox.
2. In Game Settings → Security, enable **Allow Studio Access to API Services**.
3. Test with a published place, not only an unpublished local file.

## First test checklist
1. Join with two players.
2. Confirm each player has their own 30:00 timer.
3. Start the janitor job with one player; only that player's timer pauses.
4. Collect leaves and verify money changes server-side.
5. Find secrets and verify `SecretsFound` changes.
6. Leave/rejoin and verify saved money/secrets.
7. Wait for a night event and test the night-only secrets.
8. Test on mobile controls before publishing.

## Architecture note
The project is moving from the original MVP into a modular v2 architecture. During the transition, avoid having two scripts listen to the same gameplay RemoteEvent or maintain separate copies of player money/secrets.
