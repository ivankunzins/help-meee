# SECRET VILLAGE — запуск в Roblox Studio

## 1. Создать структуру
В Roblox Studio открой проект и создай:

- `ServerScriptService > Script` — вставь содержимое `src/ServerScriptService/SecretVillageFull.server.lua`.
- `StarterPlayer > StarterPlayerScripts > LocalScript` — вставь `src/StarterPlayer/StarterPlayerScripts/SecretVillage.client.lua`.

Старый `SecretVillage.server.lua` отключи, чтобы две версии систем не запускались одновременно.

## 2. Сохранения
Для тестирования DataStore в Studio включи:
`Game Settings > Security > Enable Studio Access to API Services`.

Для реальной публикации игра должна быть опубликована через Roblox Studio.

## 3. Что уже работает
- деревня и дороги;
- 2 водоёма;
- секретная дверь под водой;
- секретная комната;
- 4 награды в комнате: MagicCarpet, EnergySword, RocketBlaster, BoomCannon;
- продавец и продажа еды;
- подсказка за $500;
- профессия дворника за $100;
- пауза личного таймера на время смены;
- 90 листьев по $1;
- 3 транспорта с VehicleSeat;
- странствующий торговец;
- сохранение денег, найденных секретов, профессии и предметов;
- автосохранение каждые 2 минуты;
- базовый HUD с таймером, деньгами и секретами.

## 4. Важное
Это программный прототип: модели домов, машин, предметов и UI пока создаются из Roblox Parts. Следующий production-проход должен заменить прототипные Parts на красивые модели, добавить анимации, звук, полноценный магазин, 100 секретов, задания, инвентарь и безопасную монетизацию.
