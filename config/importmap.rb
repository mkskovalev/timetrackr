# Pin npm packages by running ./bin/importmap

pin "application", preload: true
pin "@hotwired/turbo-rails", to: "turbo.min.js", preload: true
pin "@hotwired/stimulus", to: "https://ga.jspm.io/npm:@hotwired/stimulus@3.2.2/dist/stimulus.js"
pin "@hotwired/stimulus-loading", to: "stimulus-loading.js", preload: true
pin_all_from "app/javascript/controllers", under: "controllers"
pin "stimulus-use", to: "https://ga.jspm.io/npm:stimulus-use@0.51.3/dist/index.js"
pin "stimulus-notification", to: "https://ga.jspm.io/npm:stimulus-notification@2.2.0/dist/stimulus-notification.mjs"
pin "hotkeys-js", to: "https://ga.jspm.io/npm:hotkeys-js@3.12.0/dist/hotkeys.esm.js"
pin "slim-select", to: "https://ga.jspm.io/npm:slim-select@2.6.0/dist/slimselect.es.js"
pin "@rails/request.js", to: "https://ga.jspm.io/npm:@rails/request.js@0.0.8/src/index.js"
pin "sortablejs", to: "https://ga.jspm.io/npm:sortablejs@1.15.2/modular/sortable.esm.js"
pin "stimulus-sortable", to: "https://ga.jspm.io/npm:stimulus-sortable@4.1.1/dist/stimulus-sortable.mjs"
pin "@stimulus-components/clipboard", to: "https://ga.jspm.io/npm:@stimulus-components/clipboard@5.0.0/dist/stimulus-clipboard.mjs"
pin_all_from "app/javascript/custom", under: "custom"
