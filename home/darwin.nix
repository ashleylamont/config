{config, pkgs, lib, ...}:
{
    # Use native macOS pinentry (from GPG Suite) so GUI apps like WebStorm,
    # GitButler, etc. can trigger the passphrase dialog without needing X11/GTK.
    services.gpg-agent.pinentry.package = pkgs.pinentry_mac;

    programs.zsh = {
        enable = true;
        oh-my-zsh = {
            enable = true;
            plugins = [
                "iterm2"
                "macos"
            ];
        };
        shellAliases = {
            # MacOS DNS
            flushdns = "sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder";
        };
    };

    # iTerm2 Dynamic Profile - captures the colors/font/keyboard map from the
    # interactively-configured "Default" profile so a fresh machine starts with
    # the same look instead of iTerm2's stock theme. Shows up as a separate
    # selectable profile named "Nix" (a distinct Guid from "Default") rather than
    # overwriting the interactive one - set it as your default in iTerm2's
    # profile list if you want it to be what new windows/tabs use.
    home.file."Library/Application Support/iTerm2/DynamicProfiles/nix.json".text = ''
        {
          "Profiles": [
            {
              "ASCII Anti Aliased": true,
              "ASCII Ligatures": false,
              "Ambiguous Double Width": false,
              "Ansi 0 Color": {
                "Blue Component": 0,
                "Color Space": "sRGB",
                "Green Component": 0,
                "Red Component": 0
              },
              "Ansi 0 Color (Dark)": {
                "Blue Component": 0,
                "Color Space": "sRGB",
                "Green Component": 0,
                "Red Component": 0
              },
              "Ansi 0 Color (Light)": {
                "Blue Component": 0,
                "Color Space": "sRGB",
                "Green Component": 0,
                "Red Component": 0
              },
              "Ansi 1 Color": {
                "Blue Component": 0.4980392156862745,
                "Color Space": "sRGB",
                "Green Component": 0.43137254901960786,
                "Red Component": 0.9607843137254902
              },
              "Ansi 1 Color (Dark)": {
                "Blue Component": 0.4980392156862745,
                "Color Space": "sRGB",
                "Green Component": 0.43137254901960786,
                "Red Component": 0.9607843137254902
              },
              "Ansi 1 Color (Light)": {
                "Blue Component": 0.4980392156862745,
                "Color Space": "sRGB",
                "Green Component": 0.43137254901960786,
                "Red Component": 0.9607843137254902
              },
              "Ansi 10 Color": {
                "Blue Component": 0.6549019607843137,
                "Color Space": "sRGB",
                "Green Component": 0.8392156862745098,
                "Red Component": 0.9098039215686274
              },
              "Ansi 10 Color (Dark)": {
                "Blue Component": 0.6549019607843137,
                "Color Space": "sRGB",
                "Green Component": 0.8392156862745098,
                "Red Component": 0.9098039215686274
              },
              "Ansi 10 Color (Light)": {
                "Blue Component": 0.6549019607843137,
                "Color Space": "sRGB",
                "Green Component": 0.8392156862745098,
                "Red Component": 0.9098039215686274
              },
              "Ansi 11 Color": {
                "Blue Component": 0.4745098039215686,
                "Color Space": "sRGB",
                "Green Component": 0.7333333333333333,
                "Red Component": 0.9450980392156862
              },
              "Ansi 11 Color (Dark)": {
                "Blue Component": 0.4745098039215686,
                "Color Space": "sRGB",
                "Green Component": 0.7333333333333333,
                "Red Component": 0.9450980392156862
              },
              "Ansi 11 Color (Light)": {
                "Blue Component": 0.4745098039215686,
                "Color Space": "sRGB",
                "Green Component": 0.7333333333333333,
                "Red Component": 0.9450980392156862
              },
              "Ansi 12 Color": {
                "Blue Component": 0.8705882352941177,
                "Color Space": "sRGB",
                "Green Component": 0.7725490196078432,
                "Red Component": 0.5019607843137255
              },
              "Ansi 12 Color (Dark)": {
                "Blue Component": 0.8705882352941177,
                "Color Space": "sRGB",
                "Green Component": 0.7725490196078432,
                "Red Component": 0.5019607843137255
              },
              "Ansi 12 Color (Light)": {
                "Blue Component": 0.8705882352941177,
                "Color Space": "sRGB",
                "Green Component": 0.7725490196078432,
                "Red Component": 0.5019607843137255
              },
              "Ansi 13 Color": {
                "Blue Component": 0.7333333333333333,
                "Color Space": "sRGB",
                "Green Component": 0.5803921568627451,
                "Red Component": 0.6980392156862745
              },
              "Ansi 13 Color (Dark)": {
                "Blue Component": 0.7333333333333333,
                "Color Space": "sRGB",
                "Green Component": 0.5803921568627451,
                "Red Component": 0.6980392156862745
              },
              "Ansi 13 Color (Light)": {
                "Blue Component": 0.7333333333333333,
                "Color Space": "sRGB",
                "Green Component": 0.5803921568627451,
                "Red Component": 0.6980392156862745
              },
              "Ansi 14 Color": {
                "Blue Component": 0.7333333333333333,
                "Color Space": "sRGB",
                "Green Component": 0.8,
                "Red Component": 0.615686274509804
              },
              "Ansi 14 Color (Dark)": {
                "Blue Component": 0.7333333333333333,
                "Color Space": "sRGB",
                "Green Component": 0.8,
                "Red Component": 0.615686274509804
              },
              "Ansi 14 Color (Light)": {
                "Blue Component": 0.7333333333333333,
                "Color Space": "sRGB",
                "Green Component": 0.8,
                "Red Component": 0.615686274509804
              },
              "Ansi 15 Color": {
                "Blue Component": 1,
                "Color Space": "sRGB",
                "Green Component": 1,
                "Red Component": 1
              },
              "Ansi 15 Color (Dark)": {
                "Blue Component": 1,
                "Color Space": "sRGB",
                "Green Component": 1,
                "Red Component": 1
              },
              "Ansi 15 Color (Light)": {
                "Blue Component": 1,
                "Color Space": "sRGB",
                "Green Component": 1,
                "Red Component": 1
              },
              "Ansi 2 Color": {
                "Blue Component": 0.4588235294117647,
                "Color Space": "sRGB",
                "Green Component": 0.788235294117647,
                "Red Component": 0.7450980392156863
              },
              "Ansi 2 Color (Dark)": {
                "Blue Component": 0.4588235294117647,
                "Color Space": "sRGB",
                "Green Component": 0.788235294117647,
                "Red Component": 0.7450980392156863
              },
              "Ansi 2 Color (Light)": {
                "Blue Component": 0.4588235294117647,
                "Color Space": "sRGB",
                "Green Component": 0.788235294117647,
                "Red Component": 0.7450980392156863
              },
              "Ansi 3 Color": {
                "Blue Component": 0.4117647058823529,
                "Color Space": "sRGB",
                "Green Component": 0.5254901960784314,
                "Red Component": 0.9607843137254902
              },
              "Ansi 3 Color (Dark)": {
                "Blue Component": 0.4117647058823529,
                "Color Space": "sRGB",
                "Green Component": 0.5254901960784314,
                "Red Component": 0.9607843137254902
              },
              "Ansi 3 Color (Light)": {
                "Blue Component": 0.4117647058823529,
                "Color Space": "sRGB",
                "Green Component": 0.5254901960784314,
                "Red Component": 0.9607843137254902
              },
              "Ansi 4 Color": {
                "Blue Component": 0.7725490196078432,
                "Color Space": "sRGB",
                "Green Component": 0.8509803921568627,
                "Red Component": 0.25882352941176473
              },
              "Ansi 4 Color (Dark)": {
                "Blue Component": 0.7725490196078432,
                "Color Space": "sRGB",
                "Green Component": 0.8509803921568627,
                "Red Component": 0.25882352941176473
              },
              "Ansi 4 Color (Light)": {
                "Blue Component": 0.7725490196078432,
                "Color Space": "sRGB",
                "Green Component": 0.8509803921568627,
                "Red Component": 0.25882352941176473
              },
              "Ansi 5 Color": {
                "Blue Component": 0.7176470588235294,
                "Color Space": "sRGB",
                "Green Component": 0.5254901960784314,
                "Red Component": 0.8235294117647058
              },
              "Ansi 5 Color (Dark)": {
                "Blue Component": 0.7176470588235294,
                "Color Space": "sRGB",
                "Green Component": 0.5254901960784314,
                "Red Component": 0.8235294117647058
              },
              "Ansi 5 Color (Light)": {
                "Blue Component": 0.7176470588235294,
                "Color Space": "sRGB",
                "Green Component": 0.5254901960784314,
                "Red Component": 0.8235294117647058
              },
              "Ansi 6 Color": {
                "Blue Component": 0.5411764705882353,
                "Color Space": "sRGB",
                "Green Component": 0.796078431372549,
                "Red Component": 0.21568627450980393
              },
              "Ansi 6 Color (Dark)": {
                "Blue Component": 0.5411764705882353,
                "Color Space": "sRGB",
                "Green Component": 0.796078431372549,
                "Red Component": 0.21568627450980393
              },
              "Ansi 6 Color (Light)": {
                "Blue Component": 0.5411764705882353,
                "Color Space": "sRGB",
                "Green Component": 0.796078431372549,
                "Red Component": 0.21568627450980393
              },
              "Ansi 7 Color": {
                "Blue Component": 0.7647058823529411,
                "Color Space": "sRGB",
                "Green Component": 0.7647058823529411,
                "Red Component": 0.8352941176470589
              },
              "Ansi 7 Color (Dark)": {
                "Blue Component": 0.7647058823529411,
                "Color Space": "sRGB",
                "Green Component": 0.7647058823529411,
                "Red Component": 0.8352941176470589
              },
              "Ansi 7 Color (Light)": {
                "Blue Component": 0.7647058823529411,
                "Color Space": "sRGB",
                "Green Component": 0.7647058823529411,
                "Red Component": 0.8352941176470589
              },
              "Ansi 8 Color": {
                "Blue Component": 0.4980392156862745,
                "Color Space": "sRGB",
                "Green Component": 0.5176470588235295,
                "Red Component": 0.5333333333333333
              },
              "Ansi 8 Color (Dark)": {
                "Blue Component": 0.4980392156862745,
                "Color Space": "sRGB",
                "Green Component": 0.5176470588235295,
                "Red Component": 0.5333333333333333
              },
              "Ansi 8 Color (Light)": {
                "Blue Component": 0.4980392156862745,
                "Color Space": "sRGB",
                "Green Component": 0.5176470588235295,
                "Red Component": 0.5333333333333333
              },
              "Ansi 9 Color": {
                "Blue Component": 0.6392156862745098,
                "Color Space": "sRGB",
                "Green Component": 0.6313725490196078,
                "Red Component": 0.8980392156862745
              },
              "Ansi 9 Color (Dark)": {
                "Blue Component": 0.6392156862745098,
                "Color Space": "sRGB",
                "Green Component": 0.6313725490196078,
                "Red Component": 0.8980392156862745
              },
              "Ansi 9 Color (Light)": {
                "Blue Component": 0.6392156862745098,
                "Color Space": "sRGB",
                "Green Component": 0.6313725490196078,
                "Red Component": 0.8980392156862745
              },
              "BM Growl": true,
              "Background Color": {
                "Blue Component": 0.09411764705882353,
                "Color Space": "sRGB",
                "Green Component": 0.09411764705882353,
                "Red Component": 0.09411764705882353
              },
              "Background Color (Dark)": {
                "Blue Component": 0.09411764705882353,
                "Color Space": "sRGB",
                "Green Component": 0.09411764705882353,
                "Red Component": 0.09411764705882353
              },
              "Background Color (Light)": {
                "Blue Component": 0.09411764705882353,
                "Color Space": "sRGB",
                "Green Component": 0.09411764705882353,
                "Red Component": 0.09411764705882353
              },
              "Badge Color": {
                "Alpha Component": 0.5,
                "Blue Component": 0.13960540294647217,
                "Color Space": "P3",
                "Green Component": 0.25479039549827576,
                "Red Component": 0.9292940497398376
              },
              "Badge Color (Dark)": {
                "Alpha Component": 0.5,
                "Blue Component": 0.13960540294647217,
                "Color Space": "P3",
                "Green Component": 0.25479039549827576,
                "Red Component": 0.9292940497398376
              },
              "Badge Color (Light)": {
                "Alpha Component": 0.5,
                "Blue Component": 0.13960540294647217,
                "Color Space": "P3",
                "Green Component": 0.25479039549827576,
                "Red Component": 0.9292940497398376
              },
              "Blinking Cursor": false,
              "Blur": false,
              "Bold Color": {
                "Blue Component": 0.788235294117647,
                "Color Space": "sRGB",
                "Green Component": 0.8156862745098039,
                "Red Component": 0.8352941176470589
              },
              "Bold Color (Dark)": {
                "Blue Component": 0.788235294117647,
                "Color Space": "sRGB",
                "Green Component": 0.8156862745098039,
                "Red Component": 0.8352941176470589
              },
              "Bold Color (Light)": {
                "Blue Component": 0.788235294117647,
                "Color Space": "sRGB",
                "Green Component": 0.8156862745098039,
                "Red Component": 0.8352941176470589
              },
              "Character Encoding": 4,
              "Close Sessions On End": true,
              "Columns": 80,
              "Cursor Boost": 0,
              "Cursor Color": {
                "Blue Component": 0.803921568627451,
                "Color Space": "sRGB",
                "Green Component": 0.7686274509803922,
                "Red Component": 0.9372549019607843
              },
              "Cursor Color (Dark)": {
                "Blue Component": 0.803921568627451,
                "Color Space": "sRGB",
                "Green Component": 0.7686274509803922,
                "Red Component": 0.9372549019607843
              },
              "Cursor Color (Light)": {
                "Blue Component": 0.803921568627451,
                "Color Space": "sRGB",
                "Green Component": 0.7686274509803922,
                "Red Component": 0.9372549019607843
              },
              "Cursor Guide Color": {
                "Alpha Component": 0.25,
                "Blue Component": 0.9912572503089905,
                "Color Space": "P3",
                "Green Component": 0.9204778671264648,
                "Red Component": 0.7486259341239929
              },
              "Cursor Guide Color (Dark)": {
                "Alpha Component": 0.25,
                "Blue Component": 0.9912572503089905,
                "Color Space": "P3",
                "Green Component": 0.9204778671264648,
                "Red Component": 0.7486259341239929
              },
              "Cursor Guide Color (Light)": {
                "Alpha Component": 0.25,
                "Blue Component": 0.9912572503089905,
                "Color Space": "P3",
                "Green Component": 0.9204778671264648,
                "Red Component": 0.7486259341239929
              },
              "Cursor Text Color": {
                "Blue Component": 0.09411764705882353,
                "Color Space": "sRGB",
                "Green Component": 0.09411764705882353,
                "Red Component": 0.09411764705882353
              },
              "Cursor Text Color (Dark)": {
                "Blue Component": 0.09411764705882353,
                "Color Space": "sRGB",
                "Green Component": 0.09411764705882353,
                "Red Component": 0.09411764705882353
              },
              "Cursor Text Color (Light)": {
                "Blue Component": 0.09411764705882353,
                "Color Space": "sRGB",
                "Green Component": 0.09411764705882353,
                "Red Component": 0.09411764705882353
              },
              "Cursor Type": 1,
              "Custom Command": "No",
              "Custom Directory": "No",
              "Disable Window Resizing": true,
              "Flashing Bell": false,
              "Foreground Color": {
                "Blue Component": 0.788235294117647,
                "Color Space": "sRGB",
                "Green Component": 0.8156862745098039,
                "Red Component": 0.8352941176470589
              },
              "Foreground Color (Dark)": {
                "Blue Component": 0.788235294117647,
                "Color Space": "sRGB",
                "Green Component": 0.8156862745098039,
                "Red Component": 0.8352941176470589
              },
              "Foreground Color (Light)": {
                "Blue Component": 0.788235294117647,
                "Color Space": "sRGB",
                "Green Component": 0.8156862745098039,
                "Red Component": 0.8352941176470589
              },
              "Guid": "3f1c9b7e-6a2d-4e0a-9c3a-8b8b1a9e2b71",
              "Horizontal Spacing": 1,
              "Idle Code": 0,
              "Jobs to Ignore": [
                "rlogin",
                "ssh",
                "slogin",
                "telnet"
              ],
              "Keyboard Map": {
                "0x7f-0x100000": {
                  "Action": 11,
                  "Text": "0x15"
                },
                "0x7f-0x80000": {
                  "Action": 11,
                  "Text": "0x1b 0x7f"
                },
                "f702-0x280000": {
                  "Action": 10,
                  "Text": "b"
                },
                "f702-0x300000": {
                  "Action": 11,
                  "Text": "0x1"
                },
                "f703-0x280000": {
                  "Action": 10,
                  "Text": "f"
                },
                "f703-0x300000": {
                  "Action": 11,
                  "Text": "0x5"
                },
                "f728-0x0": {
                  "Action": 11,
                  "Text": "0x4"
                },
                "f728-0x80000": {
                  "Action": 10,
                  "Text": "d"
                }
              },
              "Link Color": {
                "Alpha Component": 1,
                "Blue Component": 0.7093239426612854,
                "Color Space": "P3",
                "Green Component": 0.35333043336868286,
                "Red Component": 0.14513972401618958
              },
              "Link Color (Dark)": {
                "Alpha Component": 1,
                "Blue Component": 0.7093239426612854,
                "Color Space": "P3",
                "Green Component": 0.35333043336868286,
                "Red Component": 0.14513972401618958
              },
              "Link Color (Light)": {
                "Alpha Component": 1,
                "Blue Component": 0.7093239426612854,
                "Color Space": "P3",
                "Green Component": 0.35333043336868286,
                "Red Component": 0.14513972401618958
              },
              "Load Shell Integration Automatically": true,
              "Match Background Color": {
                "Alpha Component": 1,
                "Blue Component": 0.32116127014160156,
                "Color Space": "P3",
                "Green Component": 0.9860088229179382,
                "Red Component": 0.9969714283943176
              },
              "Match Background Color (Dark)": {
                "Alpha Component": 1,
                "Blue Component": 0,
                "Color Space": "P3",
                "Green Component": 1,
                "Red Component": 1
              },
              "Match Background Color (Light)": {
                "Alpha Component": 1,
                "Blue Component": 0,
                "Color Space": "P3",
                "Green Component": 1,
                "Red Component": 1
              },
              "Minimum Contrast": 0.35,
              "Minimum Contrast (Dark)": 0.35,
              "Minimum Contrast (Light)": 0.35,
              "Mouse Reporting": true,
              "Name": "Nix",
              "Non Ascii Font": "Monaco 12",
              "Non-ASCII Anti Aliased": true,
              "Normal Font": "CommitMonoNFM-Regular 12",
              "Open Password Manager Automatically": false,
              "Option Key Sends": 0,
              "Prompt Before Closing 2": false,
              "Right Option Key Sends": 0,
              "Rows": 25,
              "Screen": -1,
              "Scrollback Lines": 500000,
              "Selected Text Color": {
                "Blue Component": 0.788235294117647,
                "Color Space": "sRGB",
                "Green Component": 0.8156862745098039,
                "Red Component": 0.8352941176470589
              },
              "Selected Text Color (Dark)": {
                "Blue Component": 0.788235294117647,
                "Color Space": "sRGB",
                "Green Component": 0.8156862745098039,
                "Red Component": 0.8352941176470589
              },
              "Selected Text Color (Light)": {
                "Blue Component": 0.788235294117647,
                "Color Space": "sRGB",
                "Green Component": 0.8156862745098039,
                "Red Component": 0.8352941176470589
              },
              "Selection Color": {
                "Blue Component": 0.21176470588235294,
                "Color Space": "sRGB",
                "Green Component": 0.21176470588235294,
                "Red Component": 0.21176470588235294
              },
              "Selection Color (Dark)": {
                "Blue Component": 0.21176470588235294,
                "Color Space": "sRGB",
                "Green Component": 0.21176470588235294,
                "Red Component": 0.21176470588235294
              },
              "Selection Color (Light)": {
                "Blue Component": 0.21176470588235294,
                "Color Space": "sRGB",
                "Green Component": 0.21176470588235294,
                "Red Component": 0.21176470588235294
              },
              "Send Code When Idle": false,
              "Silence Bell": false,
              "Smart Cursor Color": true,
              "Smart Cursor Color (Dark)": true,
              "Smart Cursor Color (Light)": true,
              "Sync Title": false,
              "Tags": [],
              "Terminal Type": "xterm-256color",
              "Transparency": 0,
              "Unlimited Scrollback": false,
              "Use Bold Font": true,
              "Use Bright Bold": true,
              "Use Cursor Guide (Light)": false,
              "Use Italic Font": true,
              "Use Non-ASCII Font": false,
              "Use Separate Colors for Light and Dark Mode": false,
              "Vertical Spacing": 1,
              "Visual Bell": true,
              "Window Type": 0
            }
          ]
        }
    '';
}