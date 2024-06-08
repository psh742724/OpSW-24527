#!/bin/bash

# 파일명: Detailed_Phonebook.sh

Phonebook="phonebook.txt"

# 지역번호 - 지역명
declare -A Area_Codes=( ["02"]="서울" ["031"]="경기" ["032"]="인천" ["033"]="강원" ["041"]="충남" ["042"]="대전" ["043"]="충북" ["044"]="세종" ["051"]="부산" ["052"]="울산" ["053"]="대구" ["054"]="경북" ["055"]="경남" ["061"]="전남" ["062"]="광주" ["063"]="전북" ["064"]="제주" )

# 인수 검사 - 인수의 개수가 2개가 아닐 경우 거절
if [[ $# -ne 2 ]]; 
then
    echo "사용법: $0 이름 전화번호"
    exit 1
fi

Name=$1
Phone=$2

# 전화번호 형식 및 지역번호 검증
if ! [[ $Phone =~ ^([0-9]{2,3})-([0-9]{3,4})-([0-9]{4})$ ]]; 
then
    echo "잘못된 전화번호 형식입니다. 예: 02-1234-5678"
    exit 2
fi

Area_Code=${BASH_REMATCH[1]}
if [[ -z ${Area_Codes[$Area_Code]} ]]; 
then
    echo "지원하지 않는 지역번호입니다."
    exit 3
fi
Area=${Area_codes[$Area_Code]}

# 결과 출력 코드 - 전화번호부 검색 및 처리
if [[ -f $Phonebook ]]; then
    # 전화번호부에서 이름 검색
    Line=$(grep "$Name " $Phonebook)
    if [[ -n $Line ]]; then
        # 이름이 존재하면 전화번호 비교
        Old_Phone=$(echo $Line | cut -d' ' -f2)
        if [[ $Old_Phone == $Phone ]]; then
            echo "$Name 의 전화번호가 이미 존재합니다: $Phone"
            exit 0
        else
            # 새 전화번호로 업데이트
            sed -i "/^$Name /d" $Phonebook
            echo "$Name $Phone $Area" >> $Phonebook
            echo "$Name 의 새로운 전화번호를 추가했습니다: $Phone"
        fi
    else
        # 새로운 항목 추가
        echo "$Name $Phone $Area" >> $Phonebook
        echo "$Name 을(를) 전화번호부에 추가했습니다: $Phone"
    fi
    
else
    # 파일이 없으면 새로 생성
    echo "$Name $Phone $Area" > $Phonebook
    echo "새로운 전화번호부를 생성하고 $Name 을(를) 추가했습니다: $Phone"
fi

# 이름순으로 정렬
sort $Phonebook -o $Phonebook

echo "전화번호부가 업데이트 되었습니다."
