import { Elm } from './Main.elm';


const app = Elm.Main.init({
  node: document.getElementById('root'),
  flags: {
    height: window.innerHeight,
    width: window.innerWidth
  }
});
