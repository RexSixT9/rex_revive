# QBOX REVIVE

A lightweight and simple **revive and respawn script** for **QBOX / QBCore** framework built with **ox_lib**.  
Players can self-revive using a keybind, and admins can revive or respawn players using commands.

---

## 📦 Installation

1. Download or clone this repository.  
2. Place the `rex_revive` folder inside your server’s `resources` directory.  
3. Add the following lines to your `server.cfg` in the correct order:

   ```cfg
   ensure ox_lib
   ensure qbx_core
   ensure rx_revive
   
4. Configure options in client.lua and server.lua as needed (revive time, permissions, etc.)

Dependencies
ox_lib
qbx_core
