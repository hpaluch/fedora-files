# Lenovo notebook settings

Here are my random notes on setting up Lenovo notebook
with Fedora 43 (Beta) Workstation (GNOME/Wayland).
See [my wiki](https://github.com/hpaluch/hpaluch.github.io/wiki/Lenovo)
for hardware details.

# Airplane mode

I want to have Airplane mode active on boot. There is NetworkManager framework
called "RfKill" - some terse information is on
https://networkmanager.dev/docs/rfkill/

Manual disable can be done with:

```shell
$ nmcli radio all off
$ nmcli radio

WIFI-HW  WIFI      WWAN-HW  WWAN
enabled  disabled  missing  disabled
```

Right after `nmcli radio all off` command you should see `Airplane mode` in
GNOME status.

To Disable Radio interfaces (Wi-Fi, Bluetooth) as default:

```shell
sudo grubby --update-kernel=ALL --args=rfkill.default_state=0
sudo grubby --update-kernel=ALL --args=systemd.restore_state=0
```

Note: I'm not sure about 2nd parameter - it is supposed to stop
systemd to restore `rfkill` state stored at shutdown time.

Note: it may sound weird, but `rfkill` is device right in kernel (under
`net/rfkill`) - so we have to control it with boot parameter
`rfkill.default_state=0` ( 0 = radio disabled, 1 = radio enabled).

Additionally I created file `/etc/NetworkManager/conf.d/70-disable-wifi.conf`
with contents:

```ini
[main]
WirelessEnabled=false
```

And reboot - hopefully your GDM/GNOME session will now start in Airplane mode...

Debug: after reboot try this command to see how `rfkill` state is changed:

```shell
journalctl -b | grep rfkill
```

