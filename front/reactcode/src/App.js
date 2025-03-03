import { Routes, Route, Outlet, Link, BrowserRouter } from "react-router-dom";
import './App.css';
import HomePage from './view/pages/homepage';
import LiveRoomPage from './view/pages/liveroom';

function App() {

  return (
    <BrowserRouter>
      <Routes>
        <Route path="/" element={<HomePage />} />
        <Route path="liveroom/:idroom" element={<LiveRoomPage />} />
      </Routes>
    </BrowserRouter>
  );

}



export default App;
