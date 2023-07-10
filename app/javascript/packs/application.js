import Rails from "@rails/ujs"
import Turbolinks from "turbolinks"

import * as ActiveStorage from "@rails/activestorage"
import "channels"
import "bootstrap"
import "bootstrap/dist/css/bootstrap";
import { normalizeCacheGroups } from "webpack/lib/optimize/SplitChunksPlugin"
require("@rails/ujs").start()
require("turbolinks").start()
require("@rails/activestorage").start()
require("channels")
require("jquery")

require("trix")
require("@rails/actiontext")
require("@nathanvda/cocoon")
