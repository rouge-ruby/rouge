import foo.bar
import quux.*


object noCompression {

	method compressedSize(fileSize) {
		return fileSize
	}
}

object reflate {

	method compressedSize(fileSize) {
		return fileSize * 0.8
	}
}

class Content {
	var name

	constructor(aName) {
		name = aName
	}

	method isLight() {
		return self.size() > 150 * 1024 ** 2
	}

	method canBeUploadedTo(aRepo) {
		return aRepo.canUpload(self)
	}

	method longName() {
		return name.length()
	}
}

class TextFile inherits Content {
	var lines

	constructor(aName, someLines) = super(aName) {
		lines = someLines
	}

	method size() {
		return lines.sum({ line => line.size() }) * 16
	}
}

class BinaryFile inherits Content {
	var bytes
	var compressionMethod = noCompression

	constructor(aName, someBytes) = super(aName) {
		bytes = someBytes
	}

	method size() {
		return compressionMethod.compressedSize(bytes.size())
	}

	method compressionMethod(aCompressionMethod) {
		compressionMethod = aCompressionMethod
	}
}

program "aProgram" {
        pepita.fly(20)
        const t = new Trainer()
        t.train(pepita)
}

test "pepita should spent twice the kilometers flown" {
        pepita.energy(100)
        pepita.fly(20)
        assert.equals(60, pepita.energy())
}

mixin Walks {
	var walkedDistance = 0

	method walk(distance) {
		walkedDistance += distance
	}

	method walkedDistance() = walkedDistance
}

class WalkingBird mixed with Walks {}

mixin M1 {}

mixin M2 {}

class C mixed with M1 and M2 {}

//object Set {
//
//}

object Set {

    /*
    method add(element){
    }
    */
}

package bar {

    object foo {

        var numbers = [1, 2,3].map({it => it + 1})
        var bar = "asd"
        var quux = #{}
        var ruux = [1, 2, "foo", [1]]


        method sayHi() = return "Hi!"

        method close() = return true or true and false not true

        method sayBye(_some) {
            var a = 0
            a++
            a--
            if(1>0) {
                return 0
            } else {
                return 1
            }

            return 1 === 2
            return 1 == 2
        }
    }
}
