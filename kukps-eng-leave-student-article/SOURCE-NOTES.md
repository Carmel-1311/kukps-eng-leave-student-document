# หลักฐานที่ใช้และขอบเขตข้อสรุป

ตรวจข้อมูลวันที่ 15 ตุลาคม 2569 โดยไม่เปลี่ยนโค้ดระบบ และไม่เข้าถึงฐานข้อมูลจริงหรือแฟ้ม environment

| เนื้อหา                                   | แหล่งอ้างอิง                                                                               |
| ----------------------------------------- | ------------------------------------------------------------------------------------------ |
| ที่มา วัตถุประสงค์ ชื่อผู้เขียน ที่ปรึกษา | `structure-ref/PreProject .docx`                                                           |
| รูปแบบบทความและข้อจำกัด 4 หน้า            | `structure-ref/Template.pdf`                                                               |
| รูปแบบ LaTeX แยกส่วนและฟอนต์              | `article/article/styles/article.tex` และ `article/article/main.tex`                        |
| ภาพรวมระบบและข้อจำกัด                     | `C:/Users/winne/Desktop/Web/kukps-eng-leave-request/README.md`                             |
| เทคโนโลยีที่ติดตั้ง                       | `apps/web/package.json`, `apps/api/package.json` ในโครงการเว็บ                             |
| คำขอและการเปลี่ยนสถานะ                    | `apps/api/src/leave-request/leave-request.service.ts` ในโครงการเว็บ                        |
| ข้อมูลและความสัมพันธ์                     | `apps/api/prisma/schema.prisma` ในโครงการเว็บ                                              |
| รายงานและข้อจำกัดข้อมูล                   | `docs/report-warehouse/README.md`, `docs/report-warehouse/05-etl-runbook.md` ในโครงการเว็บ |
| หน้าใช้งานแยกบทบาท                        | `apps/web/app/student`, `apps/web/app/user`, `apps/web/app/admin-staff` ในโครงการเว็บ      |

## การใช้หลักฐาน

แหล่งอ้างอิง [1]–[5] ในบทความเป็นเอกสารภายในและซอร์สโค้ด ไม่ใช่งานวิจัยภายนอกที่ผ่านการประเมิน ไม่คัดลอกผลทดลองหรือข้อมูลผู้เขียนจากบทความจำแนกอารมณ์ต้นแบบ หากต้องการเพิ่มงานวิจัยที่เกี่ยวข้องต้องตรวจเอกสารต้นฉบับและความถูกต้องของบรรณานุกรมเพิ่มเติม

เอกสารคลังข้อมูลมีทั้งสถานะล่าสุดและประวัติการออกแบบเก่า บทความยึดสถานะล่าสุดร่วมกับ README หลัก ไม่ถือว่าตัวเลขจากบันทึกการทดสอบเก่าเป็นผลทดลองของบทความ และไม่กล่าวว่า mapping หรือการตั้งเวลา ETL ครบแล้ว

แผนภาพในบทความเป็นภาพรวมแบบย่อ ไม่ได้แสดงทุกการเชื่อมต่อ บริการภายนอกและแฟ้มเอกสารอธิบายในเนื้อหา รูปหน้าจอและประวัติผู้เขียนยังไม่ใส่จนกว่าจะมีข้อมูลยืนยัน

## หลักฐานที่เพิ่มสำหรับ ระบบข้อมูลสนับสนุน และ warehouse

รากโครงการ ระบบข้อมูลสนับสนุน: `C:/Users/winne/Desktop/mono/leave-request-components` ตรวจสคีมา `apps/api/prisma/schema.prisma`, controller/service ใน `portal-leave-request-student`, `subjects`, `advisors`, `import-excel` และหน้า `apps/web/src/app/page.tsx`

รากระบบใบลา: `C:/Users/winne/Desktop/Web/kukps-eng-leave-request` ตรวจ `apps/api/src/leave-request-component/leave-request-component.service.ts`, `apps/api/src/auth/access.service.ts`, `apps/api/src/warehouse-dashboard/warehouse-live.service.ts`, `apps/api/scripts/warehouse-etl/capture-live-reference.mjs`, `docs/report-warehouse/01-schema.sql` และ runbook

ข้อจำกัดที่ตรวจจากโค้ด: ระบบข้อมูลสนับสนุน ไม่มีคีย์ภาคการศึกษาในตารางที่ตรวจ; การนำเข้าแบบเพิ่มใช้การข้ามรายการซ้ำ ไม่ใช่การอัปเดตที่ปรึกษาเดิม; การนำเข้าแบบแทนที่ล้างตารางก่อนธุรกรรมนำเข้า จึงไม่กล่าวว่าทั้งกระบวนการ rollback ได้เหมือน ETL warehouse

ไม่ได้รัน import, ETL หรือเรียกบริการจริงในการแก้บทความครั้งนี้ และไม่ได้ยืนยันการควบคุมสิทธิ์ของบริการ ระบบข้อมูลสนับสนุน โดยการทดสอบสด การอธิบายสิทธิ์รายงานอ้างอิงบริการในระบบใบลาหลัก

## หลักฐานรายละเอียดเทคโนโลยี

ตรวจ package.json ของ apps/web และ apps/api ทั้งสองโครงการ พร้อมการใช้ React Hook Form/Zod ในแบบฟอร์มยื่นใบลา, Recharts ในหน้ารายงาน, html-to-image/jsPDF ในตัวอย่างเอกสาร, xlsx ในบริการนำเข้า และ mariadb driver ใน ETL รวมถึง Dockerfile ของระบบใบลา รุ่นที่กล่าวเป็นรุ่นหรือสายรุ่นที่ประกาศใน manifest ไม่ใช่ผลตรวจ dependency ที่ติดตั้งหรือ production runtime
