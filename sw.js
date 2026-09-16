// 气味档案室 · Service Worker
// 缓存核心文件，实现离线可用

const CACHE_NAME = 'scent-archive-v1';
const CORE_ASSETS = [
  './',
  './index.html',
  './manifest.json',
  './icon.svg',
  './icon-maskable.svg'
];

// 安装：预缓存核心资源
self.addEventListener('install', (event) => {
  event.waitUntil(
    caches.open(CACHE_NAME)
      .then((cache) => cache.addAll(CORE_ASSETS))
      .then(() => self.skipWaiting())
  );
});

// 激活：清理旧缓存
self.addEventListener('activate', (event) => {
  event.waitUntil(
    caches.keys().then((keys) =>
      Promise.all(
        keys.filter((k) => k !== CACHE_NAME).map((k) => caches.delete(k))
      )
    ).then(() => self.clients.claim())
  );
});

// 请求策略：
// - 导航请求（页面）：网络优先，失败回退缓存
// - 静态资源：缓存优先，网络兜底
self.addEventListener('fetch', (event) => {
  const req = event.request;

  if (req.method !== 'GET') return;

  const isNavigation = req.mode === 'navigate';

  if (isNavigation) {
    event.respondWith(
      fetch(req)
        .then((res) => {
          const copy = res.clone();
          caches.open(CACHE_NAME).then((c) => c.put('./index.html', copy));
          return res;
        })
        .catch(() => caches.match('./index.html'))
    );
    return;
  }

  event.respondWith(
    caches.match(req).then((cached) => {
      return cached || fetch(req).then((res) => {
        const copy = res.clone();
        caches.open(CACHE_NAME).then((c) => c.put(req, copy));
        return res;
      }).catch(() => cached);
    })
  );
});
