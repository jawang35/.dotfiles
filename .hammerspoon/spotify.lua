local spotifyIcon = hs.image.imageFromPath('resources/spotify.png')

local function spotifyNotification(title, text)
  hs.notify.new({ title = title, informativeText = text }):setIdImage(spotifyIcon):send()
end

local function getCurrentSong()
  return 'Artist: ' .. hs.spotify.getCurrentArtist() .. '\nSong: ' .. hs.spotify.getCurrentTrack()
end

local function open()
  if not hs.application.launchOrFocus('Spotify') then
    hs.alert.show('Spotify not found')
  end
end

local function info()
  spotifyNotification('Currently Playing', getCurrentSong())
end

local function previous()
  hs.spotify.previous()
  spotifyNotification('⏮ Previous', getCurrentSong())
end

local function next()
  hs.spotify.next()
  spotifyNotification('⏭ Next', getCurrentSong())
end

local function pause_play()
  local playbackState = hs.spotify.getPlaybackState()
  if playbackState == hs.spotify.state_playing then
    hs.spotify.pause()
    spotifyNotification('⏸ Pause', getCurrentSong())
  else
    hs.spotify.play()
    spotifyNotification('▶️ Play', getCurrentSong())
  end
end

local function spotify(hyper)
  local spotifyModal = hs.hotkey.modal.new(hyper, 's')
  local menubar

  function spotifyModal:entered()
    menubar = hs.menubar.new()
    menubar:setTitle('Spotify Mode')
  end

  function spotifyModal:exited()
    menubar:delete()
  end

  local function execute(callback)
    spotifyModal:exit()
    callback()
  end

  spotifyModal:bind('', 'escape', function () spotifyModal:exit() end)
  spotifyModal:bind(hyper, 's', function () execute(open) end)
  spotifyModal:bind(hyper, ']', function () execute(next) end)
  spotifyModal:bind(hyper, '[', function () execute(previous) end)
  spotifyModal:bind(hyper, 'p', function () execute(pause_play) end)
  spotifyModal:bind(hyper, 'i', function () execute(info) end)
end

return spotify
