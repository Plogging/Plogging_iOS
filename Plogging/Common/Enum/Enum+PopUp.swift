//
//  Enum+PopUp.swift
//  Plogging
//
//  Created by 김혜리 on 2021/01/21.
//

import UIKit

enum PopUpType {
    // 확인
    // 1 Confirm Button
    case 운동점수안내팝업
    case 랭킹점수안내팝업
    case 비밀번호변경완료팝업
    case 인스타그램설치팝업
    
    case 애플로그인재설정
    
    // 아니요, 네
    // 2 Yes No Button
    case 종료팝업
    case 사진없이저장팝업
    case 기록삭제팝업
    case 로그아웃팝업
    case 사진저장승인
}

extension PopUpType {
    func titleMessage() -> String {
        switch self {
        case .운동점수안내팝업:
            return "각 점수별 산정기준"
        case .랭킹점수안내팝업:
            return "총점 산정기준"
        case .비밀번호변경완료팝업:
            return "비밀번호 변경완료"
        case .종료팝업:
            return "플로깅을 종료합니다."
        case .사진없이저장팝업:
            return "사진 없이 기록을 저장하시겠어요?"
        case .기록삭제팝업:
            return "정산 기록을 삭제하시겠어요?"
        case .로그아웃팝업:
            return "로그아웃 하시겠어요?"
        case .인스타그램설치팝업:
            return "인스타그램을 설치해주세요"
        case .사진저장승인:
            return "사진을 저장하시겠어요?"
        case .애플로그인재설정:
            return "애플로그인 재설정"
        }
    }
    
    func descriptionMessage() -> String {
        switch self {
        case .운동점수안내팝업:
            return "* 운동점수 (~10km)\n- 플로깅 300m 이상부터 거리점수 제공\n- 킬로미터마다 추가 점수 제공\n\n* 환경 점수\n쓰레기 수 당 점수 획득"
        case .랭킹점수안내팝업:
            return "*총점\n-거리 기반 운동점수+쓰레기 갯수 기반 환경점수\n\n*주간, 월간 랭킹\n-이번 주와 이번 달 기준"
        case .비밀번호변경완료팝업:
            return "비밀번호가 정상적으로 변경되었습니다."
        case .종료팝업:
            return "진행중인 플로깅을 종료하고\n모은 쓰레기와 조깅 기록을 정산하시겠어요?"
        case .사진없이저장팝업:
            return "앱 내의 기본 이미지로 저장되며\n저장한 기록은 수정이 불가합니다."
        case .기록삭제팝업:
            return "진행한 플로깅을 삭제한 후에는\n기록을 복구할 수 없습니다."
        case .로그아웃팝업:
            return "사용중인 플로깅 앱에서\n로그아웃 하려고 합니다."
        case .인스타그램설치팝업:
            return "인스타그램을 설치한 뒤\n플로깅 사진을 공유해주세요."
        case .사진저장승인:
            return "공유를 하기 위해\n사용자 기기에 사진이 저장됩니다."
        case .애플로그인재설정:
            return "애플로그인 재설정이 필요합니다\n설정 > Apple ID > 암호 및 보안 > Apple ID를 사용하는 앱 > Apple ID 사용 중단"
        }
    }
    
    func image() -> UIImage? {
        switch self {
        case .운동점수안내팝업:
            return UIImage(named: "grade")
        case .랭킹점수안내팝업:
            return UIImage(named: "ranking")
        case .비밀번호변경완료팝업:
            return UIImage(named: "changePassword")
        case .종료팝업:
            return UIImage(named: "popupClosePlogging")
        case .사진없이저장팝업:
            return UIImage(named: "saveWithNoPhoto")
        case .기록삭제팝업:
            return UIImage(named: "removeRecord")
        case .로그아웃팝업:
            return UIImage(named: "logout")
        case .인스타그램설치팝업:
            return UIImage(named: "instagramInstall")
        case .사진저장승인:
            return UIImage(named: "savePhoto")
        case .애플로그인재설정:
            return nil
        }
    }
    
    func numberOfButton() -> CGFloat {
        switch self {
        case .운동점수안내팝업, .랭킹점수안내팝업, .비밀번호변경완료팝업, .인스타그램설치팝업, .애플로그인재설정:
            return 1
        case .종료팝업, .사진없이저장팝업, .기록삭제팝업, .로그아웃팝업, .사진저장승인:
            return 2
        }
    }
    
    func outerViewHeight() -> CGFloat {
        switch self {
        case .운동점수안내팝업, .랭킹점수안내팝업:
            return 427
        case .비밀번호변경완료팝업, .종료팝업, .사진없이저장팝업, .기록삭제팝업, .로그아웃팝업, .인스타그램설치팝업, .사진저장승인, .애플로그인재설정:
            return 367
        }
    }
    
    func innerViewHeight() -> CGFloat {
        switch self {
        case .운동점수안내팝업, .랭킹점수안내팝업:
            return 356
        case .비밀번호변경완료팝업, .종료팝업, .사진없이저장팝업, .기록삭제팝업, .로그아웃팝업, .인스타그램설치팝업, .사진저장승인, .애플로그인재설정:
            return 281
        }
    }
    
    func topConstraint() -> CGFloat {
        switch self {
        case .운동점수안내팝업, .랭킹점수안내팝업:
            return 0
        case .비밀번호변경완료팝업, .종료팝업, .사진없이저장팝업, .기록삭제팝업, .로그아웃팝업, .인스타그램설치팝업, .사진저장승인, .애플로그인재설정:
            return 20
        }
    }
    
    func innerImageViewXConstraint() -> CGFloat {
        switch self {
        case .기록삭제팝업:
            return 25
        case .비밀번호변경완료팝업, .종료팝업, .사진없이저장팝업, .기록삭제팝업, .로그아웃팝업, .인스타그램설치팝업, .사진저장승인, .운동점수안내팝업, .랭킹점수안내팝업, .애플로그인재설정:
            return 0
        }
    }
}
