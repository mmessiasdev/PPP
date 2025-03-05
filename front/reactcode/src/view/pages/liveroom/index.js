import { appId, secret } from "../../components/helper";
import { ZegoUIKitPrebuilt } from "@zegocloud/zego-uikit-prebuilt";
import * as React from 'react';
import { useLocation } from 'react-router-dom';


function randomID(len) {
    let result = '';
    if (result) return result;
    var chars = '12345qwertyuiopasdfgh67890jklmnbvcxzMNBVCZXASDQWERTYHGFUIOLKJP',
        maxPos = chars.length,
        i;
    len = len || 5;
    for (i = 0; i < len; i++) {
        result += chars.charAt(Math.floor(Math.random() * maxPos));
    }
    return result;
}

export function getUrlParams(
    url = window.location.href
) {
    let urlStr = url.split('?')[1];
    return new URLSearchParams(urlStr);
}

export default function App() {
    const roomID = getUrlParams().get('roomID') || randomID(5);
    const isHost = !getUrlParams().get('roomID'); // Se não houver roomID na URL, é o host

    let myMeeting = async (element) => {

        // generate Kit Token
        const appID = parseInt(process.env.REACT_APP_APP_ID, 10); // Converte para número, se necessário
        const serverSecret = process.env.REACT_APP_SERVER_SECRET;
        const kitToken = ZegoUIKitPrebuilt.generateKitTokenForTest(appID, serverSecret, roomID, randomID(5), randomID(5));

        // Create instance object from Kit Token.
        const zp = ZegoUIKitPrebuilt.create(kitToken);
        // start the call
        zp.joinRoom({
            container: element,
            turnOnCameraWhenJoining: isHost, // O host começa com a câmera ligada
            showMyCameraToggleButton: isHost, // Apenas o host pode ligar/desligar a câmera
            showAudioVideoSettingsButton: isHost, // Apenas o host pode ajustar as configurações de áudio/vídeo
            showScreenSharingButton: isHost, // Apenas o host pode compartilhar a tela
            showPreJoinView: true,
            sharedLinks: [{
                url: window.location.protocol + '//' + window.location.host + window.location.pathname + '?roomID=' + roomID,
            }],
            scenario: {
                mode: ZegoUIKitPrebuilt.LiveStreaming,
                config: {
                    role: isHost ? ZegoUIKitPrebuilt.Host : ZegoUIKitPrebuilt.Audience, // Define o papel do usuário
                },
            },
        });
    };

    const location = useLocation();
    const queryParams = new URLSearchParams(location.search);
    const codigo = queryParams.get('codigo'); // Acessa o parâmetro "codigo"

    return (
        <>
            <div
                className="myCallContainer"
                ref={myMeeting}
                style={{ width: '100vw', height: '100vh' }}
            ></div>
            <div>
                <h1>Valor do Código: {codigo}</h1>
            </div>
        </>
    );
}