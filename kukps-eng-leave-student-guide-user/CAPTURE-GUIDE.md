# แผน Capture ภาพคู่มือ (9 ตุลาคม 2569)

เปิดเว็บทดสอบ: `http://localhost:3000/kukps-eng-leave-student/role-test`

1. ในโปรเจกต์ branch `ROLE_TEST` เปิด API ด้วย `pnpm dev:role-test:api`
2. เปิดเว็บด้วย `pnpm dev:role-test` (ใช้ API local ที่ `/kukps-eng-leave-student-api`)
3. เลือก Role ทีละบทบาท หากข้อมูลว่างให้กรอก Nontri ID, advisor code และ major ID ที่สัมพันธ์กับข้อมูลจริง
4. เปิด route ในตาราง โดยเติม `http://localhost:3000/kukps-eng-leave-student` ข้างหน้า
5. เก็บภาพในโฟลเดอร์ `images/` ตามชื่อที่กำหนด `main.tex` จะแสดงภาพอัตโนมัติเมื่อมีไฟล์

โหมดนี้เปิดเฉพาะ Next development เมื่อ NEXT_PUBLIC_ROLE_TEST=true และ ROLE_TEST=true API ข้ามการตรวจ token เฉพาะเมื่อ NODE_ENV=development, ROLE_TEST=true และ remoteAddress เป็น loopback เท่านั้น หากใช้ API บน server อื่นยังต้องมี token ที่ถูกต้อง ห้าม commit token โหมดนี้ทดสอบเมนูและหน้าจอ ไม่ใช่การตรวจสิทธิ์ backend

บัญชีตัวอย่าง: STUDENT=b6620503349; ADVISOR=fengtwwh (E9069, major 1); LECTURER=fengtwwh (E9069, major 1); DEPARTMENT_HEAD=fengvry (E9042, major 1); ASSOCIATE_DEAN=fengsytc (E6070, major 2); ADMIN=fengncw (major 1) ข้อมูลเหล่านี้มาจาก FakeService ต้องตรวจว่าปลายทางมีบัญชีและความสัมพันธ์ตรงกัน

`{id}` ใช้เลขคำร้องจริงที่เปิดจากรายการ ห้ามใช้เลขสมมติ รายละเอียดของผู้อนุมัติต้องเป็นรายการที่ถึงขั้นของ Role นั้นแล้ว ส่วนเอกสารต้องอนุมัติครบ

รายงานใน app/student/report และ app/user/report ปัจจุบันยัง import mock จึงคงหมายเหตุข้อมูลจำลองในคู่มือไว้

API บุคลากรผ่าน VPN: GET check-role ของ fengvry เมื่อจัดทำครั้งนี้ timeout หลัง 20 วินาที ยังไม่ยืนยันการเชื่อมต่อปลายทาง

| Role            | หัวข้อ/ภาพ                                       | Route                                                | ไฟล์ภาพ                                                                            |
| --------------- | ------------------------------------------------ | ---------------------------------------------------- | ---------------------------------------------------------------------------------- |
| STUDENT         | หน้าหลักและเมนูนิสิต                             | `/student`                                           | `images/student-home.png`                                                          |
| STUDENT         | ค้นหารายวิชา เลือก SEC และรายการวิชาที่เพิ่มแล้ว | `/student/my-class`                                  | `images/student-my-class.png`                                                      |
| STUDENT         | แบบฟอร์มเบอร์โทรศัพท์และที่อยู่                  | `/student/contact`                                   | `images/student-contact.png`                                                       |
| STUDENT         | แบบฟอร์มยื่นใบลาและรายวิชาที่ได้รับผลกระทบ       | `/student/my-leave-request/new`                      | `images/student-new-request-1.png`, `images/student-new-request-2.png`             |
| STUDENT         | รายการใบลาและแท็บสถานะ                           | `/student/my-leave-request`                          | `images/student-requests.png`                                                      |
| STUDENT         | รายละเอียดคำร้องและลำดับผู้พิจารณา               | `/student/my-leave-request/{id}`                     | `images/student-request-detail.png`                                                |
| STUDENT         | ตัวอย่างเอกสารของคำร้องที่อนุมัติครบ             | `/student/my-leave-request/{id}/document`            | `images/student-document.png`                                                      |
| STUDENT         | ตัวกรองและกราฟรายงานข้อมูลจำลอง                  | `/student/report`                                    | `images/student-report-1.png`, `images/student-report-2.png`                       |
| ADVISOR         | รายการรอพิจารณาของอาจารย์ที่ปรึกษา               | `/user/approve-leave-request/as-advisor`             | `images/advisor-queue.png`                                                         |
| ADVISOR         | รายละเอียดและปุ่มพิจารณาของอาจารย์ที่ปรึกษา      | `/user/approve-leave-request/as-advisor/{id}`        | `images/advisor-approval-1.png`, `images/advisor-approval-2.png`                   |
| ADVISOR         | รายชื่อนิสิตในที่ปรึกษา                          | `/user/my-student`                                   | `images/advisor-students.png`                                                      |
| ADVISOR         | ประวัติการอนุมัติ                                | `/user/approval-history`                             | `images/advisor-history.png`                                                       |
| ADVISOR         | ตัวกรองและรายงานอาจารย์ที่ปรึกษา                 | `/user/report/advisor`                               | `images/advisor-report-1.png`, `images/advisor-report-2.png`                       |
| ADVISOR         | การอนุมัติอัตโนมัติของฉัน — อาจารย์ที่ปรึกษา     | `/user/setting`                                      | `images/advisor-auto-approve.png`                                                  |
| DEPARTMENT_HEAD | รายละเอียดและปุ่มพิจารณาของหัวหน้าภาควิชา        | `/user/approve-leave-request/as-dept-head/{id}`      | `images/department-approval-1.png`, `images/department-approval-2.png`             |
| DEPARTMENT_HEAD | รายงานหัวหน้าภาควิชา                             | `/user/report/department-head`                       | `images/department-report-1.png`, `images/department-report-2.png`                 |
| DEPARTMENT_HEAD | การอนุมัติอัตโนมัติของฉัน — หัวหน้าภาควิชา       | `/user/setting`                                      | `images/department-auto-approve.png`                                               |
| ASSOCIATE_DEAN  | รายละเอียดและปุ่มพิจารณาของรองคณบดี              | `/user/approve-leave-request/as-associate-dean/{id}` | `images/dean-approval-1.png`, `images/dean-approval-2.png`                         |
| ASSOCIATE_DEAN  | รายงานผู้บริหาร                                  | `/user/report/executive`                             | `images/dean-report-1.png`, `images/dean-report-2.png`, `images/dean-report-3.png` |
| ASSOCIATE_DEAN  | การอนุมัติอัตโนมัติของฉัน — รองคณบดี             | `/user/setting`                                      | `images/dean-auto-approve.png`                                                     |
| LECTURER        | ใบลาที่อนุมัติแล้วในวิชาที่สอน                   | `/user/approved-request-my-class`                    | `images/lecturer-requests.png`                                                     |
| LECTURER        | รายละเอียดใบลาในวิชาที่สอน                       | `/user/approved-request-my-class/{id}`               | `images/lecturer-request-detail.png`                                               |
| LECTURER        | รายการวิชาที่สอนและ SEC                          | `/user/my-class`                                     | `images/lecturer-classes.png`                                                      |
| LECTURER        | รายงานอาจารย์ผู้สอน                              | `/user/report/lecturer`                              | `images/lecturer-report-1.png`, `images/lecturer-report-2.png`                     |
| ADMIN           | รายการใบลาภาควิชาและตัวกรอง                      | `/admin-staff/department-leave-requests`             | `images/admin-requests.png`                                                        |
| ADMIN           | ภาคการศึกษาปัจจุบันและรายการภาคการศึกษา          | `/admin-staff/academic-term-settings`                | `images/admin-terms-1.png`, `images/admin-terms-2.png`                             |
| ADMIN           | รายการคณะและสาขา                                 | `/admin-staff/department-settings`                   | `images/admin-departments-1.png`, `images/admin-departments-2.png`                 |

## Checklist ทดสอบแต่ละ Role

- เลือกบัญชีทดสอบแล้วตรวจเมนูทุกบทบาทร่วม: อาจารย์มี ADVISOR และ LECTURER; หัวหน้าภาคเพิ่ม DEPARTMENT_HEAD; รองคณบดีเพิ่ม ASSOCIATE_DEAN
- เปิดรายการและรายละเอียด ตรวจว่าข้อมูลตรงกับบัญชี/รายวิชา/ภาควิชาที่รับผิดชอบ
- นิสิต: ตรวจฟอร์มลาป่วย/ลากิจ หลักฐาน วันที่ รายวิชา SEC และการแสดงข้อผิดพลาด
- ผู้อนุมัติ: ตรวจปุ่มปรากฏเฉพาะขั้นที่ถึงแล้ว เปิดกล่องยืนยันและยกเลิกเพื่อ capture โดยไม่บันทึกผลจริง
- ผู้สอน: ตรวจใบลาที่อนุมัติครบและสถานะเปิดอ่าน (การเปิดรายละเอียดอาจบันทึกการอ่าน)
- เจ้าหน้าที่: เปิดหน้าตั้งค่าและตรวจข้อมูล โดยยังไม่กดบันทึก/ลบระหว่าง capture
- รายงาน: ตรวจตัวกรองและการแสดงข้อมูลจำลอง
- ทดสอบ route ข้ามกลุ่ม เช่น STUDENT เปิด /admin-staff ต้องถูก redirect
- ทดสอบ refresh และเปลี่ยน Role กลับที่ /role-test
- ก่อนแชร์ภาพปิดบังข้อมูลส่วนบุคคลที่ไม่จำเป็น

ภาพที่แนบในคู่มือยังเป็นกรอบ placeholder รอ capture จากหน้าจอที่มีข้อมูล ไม่ได้อ้างว่าผ่านการทดสอบ API ครบทุก Role

## ผลตรวจโค้ดและการรันก่อน merge dev (ประวัติการตรวจ)

- หน้าเลือก Role และหน้าปลายทางทั้ง 6 Role: HTTP 200
- ไม่มี session เข้าหน้านิสิต: HTTP 307 กลับหน้า Login
- STUDENT เข้าหน้า admin: HTTP 307 กลับหน้านิสิต
- Web TypeScript, ESLint และ Prettier: ผ่าน
- API TypeScript: ผ่านหลัง generate Prisma client ใหม่
- คู่มือ XeLaTeX: compile ผ่าน ไม่พบข้อความ Overfull/Underfull
- ยังไม่ได้บันทึกคำร้องหรืออนุมัติจริงเพื่อทดสอบ workflow

- API local แบบไม่ส่ง token: GET บัญชี fengsytc และนิสิต b6620503349 ตอบ HTTP 200
- Guard: loopback ใน development+ROLE_TEST ผ่าน; production, IP ภายนอก และ ROLE_TEST=false ยังปฏิเสธเมื่อไม่มี token

หมายเหตุ: นำขั้นตอนและภาพ Login ออกจากคู่มือ LaTeX แล้ว รอเชื่อมต่อระบบภายนอกก่อนเพิ่มเติมส่วนนี้

## เปลี่ยนแปลงหลัง merge dev

- ตั้งค่าอนุมัติอัตโนมัติย้ายไป `/user/setting` เป็นรายบัญชีและบทบาท
- Capture แยก ADVISOR=fengtwwh, DEPARTMENT_HEAD=fengvry, ASSOCIATE_DEAN=fengsytc
- เจ้าหน้าที่ใช้ Role ADMIN และไม่มีหน้า `/admin-staff/application-settings` แล้ว
- Role Test ใช้ signed session และ API ผ่าน `/api/backend` บนเว็บ แทนการเรียก API จาก browser โดยตรง
- หน้ารายงานยังเป็นข้อมูลจำลอง ภาพ Login ไม่รวมในคู่มือ
- ตารางภาพนี้สร้างจาก comment CAPTURE ใน main.tex ให้แทน `{id}` ด้วย ID จริงก่อนเปิดหน้า

Role Test แสดงบทบาทร่วมของอาจารย์แล้ว หัวหน้าภาคเห็นทั้ง ADVISOR/LECTURER/DEPARTMENT_HEAD หน้า `/user/setting` ต้องแสดงกฎ ADVISOR และ DEPARTMENT_HEAD ของบัญชีเดียวกัน หลังแก้ต้องกลับไปเลือกบัญชีที่ /role-test ใหม่เพื่อออก session ใหม่

## ภาพที่ใส่จริง

ใส่ภาพ 33 ไฟล์ใน PDF แล้ว ภาพเต็มจอใช้หน้ากระดาษแนวนอน ภาพ -1, -2, -3 เรียงในหัวข้อเดียวพร้อมคำบรรยายลำดับ ไม่ตัดหรือรวมภาพต้นฉบับ

ตรวจล่าสุด 9 ตุลาคม 2569: ภาพที่ LaTeX อ้างอิงมีครบทุกไฟล์แล้ว

admin-report.png ยังไม่มีหัวข้อในคู่มือปัจจุบัน จึงยังไม่ใส่แทนภาพบทบาทอื่น

## สถานะภาพล่าสุด

ตรวจวันที่ 9 ตุลาคม 2569 ภาพที่ LaTeX อ้างอิงครบทั้ง 39 ไฟล์แล้ว ไม่มีตำแหน่งรอภาพ

เพิ่ม student-request-detail.png, advisor-history.png, advisor-approval-1.png, advisor-approval-2.png, lecturer-report-1.png และ lecturer-report-2.png โดยเรียงภาพหลายส่วนตามหมายเลข

student-settings.png ถูกนำออกตามคำขอ ส่วน admin-report.png ยังไม่มีหัวข้อรองรับในคู่มือ จึงยังไม่ได้ใช้
