-- require

-- configuration

workbenchDirPath="D:Classic/WB"
uaePath="D:Classic/UAE/e-uae"
uaeConfigPath="D:Classic/.uaerc"
fileNameToRun=arg[1];

--functions
function createStartupSequence(fileNameToRun, workbenchDirPath)
    print("Creating startup sequence for: "..fileNameToRun)
    ssFile = io.open(workbenchDirPath.."/S/startup-sequence", "w")
    io.output(ssFile)
    io.write(string.format("C:WBRun %s", fileNameToRun))
    io.close(ssFile)
end

function createUAEConfig(uaeConfigPath, fileNameToRun)
    uaeConfigPathTmp=uaeConfigPath..".tmp"
    oldUaeConfigFile=io.open(uaeConfigPath, "r");
    newUaeConfigFile=io.open(uaeConfigPathTmp, "w");
    io.input(oldUaeConfigFile);
    io.output(newUaeConfigFile);
    partition,number = string.gsub(fileNameToRun, ":.*", "")
    for line in io.lines(uaeConfigPath) do
        io.write(line.."\n");
    end
    io.write(string.format("filesystem=rw,%s:%s:", partition, partition))
    io.close(oldUaeConfigFile)
    io.close(newUaeConfigFile)
    print("Running file from partition: "..partition)
end

--main logic bellow

createStartupSequence(fileNameToRun, workbenchDirPath)
createUAEConfig(uaeConfigPath, workbenchDirPath)
os.execute(string.format("%s %s.tmp", uaePath, uaeConfigPath))
