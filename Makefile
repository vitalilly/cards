all: clean build run

install:
	./scripts/deps

build:
ifeq ($(OS),Windows_NT)
	@powershell -NoProfile -Command "Remove-Item -Force app.zip 2>$$null; Compress-Archive -Path 'src\\*' -DestinationPath 'app.zip' -Force; if (Test-Path 'app.zip') { Rename-Item -Force 'app.zip' 'app.love' } else { exit 1 }"
else
	cd src && zip -r ../app.love * && cd ..
endif

run:
ifeq ($(OS),Windows_NT)
	@powershell -NoProfile -Command "& (Get-Command love).Source app.love 2>&1"
else
	-@command -v love >/dev/null 2>&1 && love app.love || @echo '"love" not found; install LÖVE to run'
endif

clean:
ifeq ($(OS),Windows_NT)
	-@del /F /Q app.love 2>nul
else
	-@rm -f app.love
endif
