# Level Zero Golf

A mobile golf career game. Everyone starts at level 0. Practise, finish rounds and sign club deals to climb.

- **Two 9-hole courses:** Level Zero Links (par 35) and Bayview Heath (par 33), a tight heathland nine inspired by a Jersey clifftop course.
- **Tap-tap swing:** the green window sits at the distance you choose and widens as you improve. Stopping in the window never gives a horror shot.
- **Real misses:** shanks, slices, snap hooks, tops, chunks, skulls, stuck in the bunker, water and out of bounds.
- **Putting:** contoured greens, a putt guide, a perfect-line sliver and a perfect-pace sliver. Anything inside 3 ft is a gimme.
- **Progression:** XP and levels, 3 skill points a level, and club deals from bargain-bin starter sets up to tour staff bags.
- **Practice area:** four challenges, one go each per day.
- **18 holes a day:** two 9-hole rounds per day, so levels are earned.
- **Handicap:** after 54 holes you get a handicap under the old UK (CONGU) system: categories, buffer zones and 0.1 increases, ready for nett and Stableford competitions.
- **Handicap card:** your golfer's face, handicap, records and trophies.

## Play it

Open the GitHub Pages link on your phone, then:

- **iPhone (Safari):** Share → Add to Home Screen
- **Android (Chrome):** ⋮ menu → Install app / Add to Home screen

It then opens full-screen from its own icon and works offline. Progress is saved on each phone.

## Publish with GitHub Pages

1. Repo **Settings → Pages**.
2. **Source:** Deploy from a branch → `main` → `/ (root)` → Save.
3. After a minute the game is live at `https://<your-username>.github.io/level-zero-golf/`.

## Updating

Edit `index.html`, then bump `VERSION` in `sw.js` (e.g. `lzg-v2`) so installed copies pick up the change on next open.

## Files

| File | What it is |
|---|---|
| `index.html` | The whole game: one file, no build step |
| `manifest.webmanifest` | App name, icon and colours for "Add to Home Screen" |
| `sw.js` | Offline support |
| `icons/` | App icons |

## Not yet

- **Online leaderboard with accounts:** the leaderboard currently shows your own bests. The plan is to connect a free Supabase project for sign-up and a shared board.
- **Majors and tours:** club contracts already run for a 3-round season as a stand-in.
