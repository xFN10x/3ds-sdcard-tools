local ui = require "ui"
local sys = require "sys"
local com = require "compression"

local win = ui.Window("CIA Manager","single",500,250)
local addzip = ui.Button(win,"Add Zip",62, 100,100,100)
local addcia = ui.Button(win,"Add .CIA",325, 100,100,100)
local label = ui.Label(win,"Add CIAS",100,0,50,50)
local c = 0
local drive = sys.Directory(sys.currentdirectory)
local assetdir = sys.Directory(sys.currentdirectory).parent
for entry in each(assetdir) do
    if entry.name == "settings.ini" then
      settingini = entry:open("read")
    end  
end 
local font = sys.File("LemonMilk.ttf")
label.fontsize = 50
win:show()

function addzip:onClick()
  local arc = ui.opendialog("Open ZIP File...", false, "Zip Files (*.zip)|*.zip")
  local probar = ui.Progressbar(win,0,230,500,50)
  if arc ~= nil then
    if com.isZip(arc) then
      probar:advance(10)
        local tempdir = sys.tempdir("Z3T")
        local z = com.Zip(arc,"read")
        print(tempdir.fullpath)
        if z:extractall(tempdir) then
          probar:advance(5)
          if z:extractall(tempdir) == 0 then
          ui.error("No Files in ZIP.")
          probar:hide()
          tempdir:removeall()
        else
          probar:advance(10)
         for entry in each(sys.Directory(tempdir.fullpath):list("*.*")) do
            print(entry.name)
            if entry.extension == ".cia" then
              
              probar:advance(20)
              c = 1
              cia = sys.File(entry.fullpath)
              print(drive.fullpath..settingini:read())
              z:extract(entry.name,drive.fullpath..settingini:read())
              if z:extract(entry.name,drive.fullpath..settingini:read()) then 
                probar:advance(999)
                sleep(1000)
                ui.msg("Moved CIA "..entry.name.." to "..entry.name,drive.fullpath..settingini:read())
                tempdir:removeall()
              else
                ui.error(z.error)
                probar:hide()
                tempdir:removeall()
              end
            end
          end
          if c == 0 then
            ui.error("No CIAS")
            probar:hide()
            tempdir:removeall()
          end
        end
        end
      else
        ui.error(z.error)
        probar:hide()
        tempdir:removeall()
      end
    end
  end
function addcia:onClick()
  local cia = ui.opendialog("Open ZIP File...", false, "CTR Importable Archive (*.cia)|*.cia")
  if ui.confirm("Move (yes) or Copy? (no)") == "yes" then
    ui.error("Not Added Yet.")
  else
    
  end
end

repeat
  ui.update()
until win.visable