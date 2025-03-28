import { appId, secret } from "../../components/helper";
import { ZegoUIKitPrebuilt } from "@zegocloud/zego-uikit-prebuilt";
import * as React from 'react';
import { useLocation } from 'react-router-dom';

function randomID(len) {
    let result = '';
    const chars = 'abcdefghijklmnopqrstuvwxyz'; // Somente letras minúsculas
    const maxPos = chars.length;
    len = len || 5; // Tamanho padrão do código é 5 caracteres

    for (let i = 0; i < len; i++) {
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
    const roomID = getUrlParams().get('code') || randomID(5);
    const isHost = !getUrlParams().get('code'); // Se não houver roomID na URL, é o host

    const handleCopyRoomID = () => {
        navigator.clipboard.writeText(roomID).then(() => {
            alert('Copiado para a área de transferência!');
        }).catch(err => {
            console.error('Erro ao copiar: ', err);
        });
    };

    let myMeeting = async (element) => {

        // generate Kit Token
        const appID = parseInt(process.env.REACT_APP_APP_ID, 10);
        const serverSecret = process.env.REACT_APP_SERVER_SECRET;
        const kitToken = ZegoUIKitPrebuilt.generateKitTokenForTest(appID, serverSecret, roomID, randomID(5), username);

        // Create instance object from Kit Token.
        const zp = ZegoUIKitPrebuilt.create(kitToken);
        // start the call
        zp.joinRoom({
            container: element,
            turnOnCameraWhenJoining: isHost, // O host começa com a câmera ligada
            showMyCameraToggleButton: isHost, // Apenas o host pode ligar/desligar a câmera
            showAudioVideoSettingsButton: isHost, // Apenas o host pode ajustar as configurações de áudio/vídeo
            showScreenSharingButton: isHost, // Apenas o host pode compartilhar a tela
            showPreJoinView: false,
            turnOnMicrophoneWhenJoining: false,
            showRoomDetailsButton: false,
            videoResolutionDefault: "720P",
            sharedLinks: [{
                url: window.location.protocol + '//' + window.location.host + window.location.pathname + '?username=' + username + '&code=' + roomID,
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
    const username = queryParams.get('username'); // Acessa o parâmetro "username"

    return (
        <>
            <div
                className="myCallContainer"
                ref={myMeeting}
                style={{ width: '100vw', height: '100vh' }}
            ></div>

            {/* Nova div para exibir o roomID e o botão de copiar */}
            <div style={{
                position: 'absolute',
                bottom: '10px', // Posiciona no canto inferior
                left: '10px',   // Posiciona no canto esquerdo
                display: 'block',
                backgroundColor: 'rgba(255, 255, 255, 0.2)',
                padding: '10px',
                borderRadius: '5px',
                boxShadow: '0 2px 10px rgba(25, 0, 255, 0.1)',
                zIndex: 1000,
                fontFamily: 'Montserrat, sans-serif' // Aplica a fonte Montserrat
            }}>
                <span>Código da live: {roomID}</span>
                <button
                    onClick={handleCopyRoomID}
                    style={{
                        marginLeft: '10px',
                        padding: '5px 10px',
                        backgroundColor: '#007bff',
                        color: '#fff',
                        border: 'none',
                        borderRadius: '3px',
                        cursor: 'pointer',
                        fontFamily: 'Montserrat, sans-serif' // Aplica a fonte Montserrat no botão
                    }}
                >
                    Copiar
                </button>
            </div>
        </>
    );
}