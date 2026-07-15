#!/usr/bin/env bash
# Scripted, representative output for a clean short GIF (mirrors assets/demo-autopilot.svg).
# Recorded by assets/demo-autopilot.tape via VHS. This is a demo script, not a real build.
G='\033[32m'; B='\033[34m'; M='\033[35m'; Y='\033[33m'; D='\033[90m'; W='\033[97m'; C='\033[36m'; R='\033[0m'
printf "${B}\xe2\x80\xba ${C}/fabrico-autopilot SPEC.md${R}\n"; sleep 1
echo; sleep 0.4
printf "${M}\xe2\x8f\xba ${W}Delegating \xe2\x86\x92 ${M}fabrico-engineering-manager${R}\n"; sleep 0.8
printf "${G}  \xe2\x9c\x93 ${W}Backlog        ${D}9 epics \xc2\xb7 23 user stories${R}\n"; sleep 0.6
printf "${G}  \xe2\x9c\x93 ${W}Architecture   ${D}Next.js + Prisma + Postgres  \xe2\x86\x92 ASSUMPTIONS.md${R}\n"; sleep 0.6
printf "${G}  \xe2\x9c\x93 ${W}Plan review    ${D}fabrico-plan-reviewer \xc2\xb7 ${G}APPROVED${R}\n"; sleep 0.6
printf "${Y}  \xe2\xa0\xbf ${W}Implementing   ${D}17/23 stories   ${G}tests \xe2\x9c\x93  lint \xe2\x9c\x93  build \xe2\x9c\x93${R}\n"; sleep 0.8
printf "${Y}  \xe2\x86\xb3 ${D}commit         \"feat: schedule + attendance\"${R}\n"; sleep 0.6
printf "${G}  \xe2\x9c\x93 ${W}Code review    ${D}fabrico-code-reviewer \xc2\xb7 ${G}0 blockers${R}\n"; sleep 0.8
printf "${M}\xe2\x8f\xba ${G}Done${W} \xe2\x86\x92 BUILD-SUMMARY.md   ${Y}(needs: STRIPE_SECRET_KEY)${R}\n"; sleep 1.5
