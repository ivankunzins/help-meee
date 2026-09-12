# Secret Village — Studio setup v3

## ServerScriptService
Включены все `.server.lua` из проекта:
- `SecretVillageCore.server.lua` — таймер, деньги, jobs, основной DataStore.
- `SecretVillageSecrets.server.lua` — 100 физических точек тайн.
- `SecretVillageSecretPersistence.server.lua` — сохранение каждой найденной тайны.
- `SecretVillageWorld.server.lua` — деревня, река, подводная комната, события.
- `SecretVillageJobs.server.lua` — 80 листьев, 16 мест рыбалки и NPC работ.
- `SecretVillageVehicles.server.lua` — транспорт.
- `SecretVillageItems.server.lua` — награды и предметы.
- `SecretVillageInventory.server.lua` — инструменты исследования.
- `SecretVillageShop.server.lua` — магазин.
- `SecretVillageOwnership.server.lua` — сохранение покупок.
- `SecretVillageEconomy.server.lua` — еда и доставка.
- `SecretVillageSocial.server.lua` — прогресс и достижения.
- `SecretVillageDaily.server.lua` — ежедневное задание.
- `SecretVillageCoop.server.lua` — SECRET #011 для двух игроков.

## StarterPlayerScripts
Оставить `SecretVillage.client.lua` — единый HUD для PC/телефона.

## ReplicatedStorage
Создай Folder `SecretVillage` и положи внутрь ModuleScript `Config` и ModuleScript `ShopConfig`. Остальное сервер создаёт автоматически.

## DataStore
1. Опубликуй Experience.
2. Game Settings → Security → включи `Allow Studio Access to API Services`.
3. Тестируй опубликованный Place.

## Проверка
1. Два игрока получают независимые 30:00.
2. Дворник: $100 вход, листья по $1, таймер игрока на паузе.
3. Рыбак: $250 вход, рыба по $8.
4. 100 секретов появляются в мире и отдельные находки сохраняются.
5. `📖 Книга тайн` показывает коллекцию 1–100.
6. Покупки транспорта сохраняются.
7. SECRET #011 открывается двумя разными игроками.
8. Ночные/атмосферные события меняют доступность секретов.

Старые `SecretVillage.server.lua` и `SecretVillageHUD.client.lua` удалены и возвращать их не нужно.
